#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef CL_TARGET_OPENCL_VERSION
#define CL_TARGET_OPENCL_VERSION 210
#endif
#include <CL/cl.h>

#define MEM_SIZE (128)
#define MAX_SOURCE_SIZE (0x100000)

int cl_main(int argc, char *argv[]) {
  cl_device_id device_id = NULL;
  cl_context context = NULL;
  cl_command_queue command_queue = NULL;
  cl_mem memobj = NULL;
  cl_program program = NULL;
  cl_kernel kernel = NULL;
  cl_platform_id platform_id = NULL;
  cl_uint ret_num_devices;
  cl_uint ret_num_platforms;
  cl_int ret;
  char string[MEM_SIZE];
  FILE *fp;
  const char *fileName = "main.cl";
  if (argc > 1)
    fileName = argv[1];
  char *source_str;
  size_t source_size;
  bool is_clsrc = true;
  /* Load the source code containing the kernel*/
  if (strstr(fileName, ".cl"))
    fp = fopen(fileName, "r");
  else {
    fp = fopen(fileName, "rb");
    is_clsrc = false;
  }
  if (!fp) {
    fprintf(stderr, "Failed to load kernel.\n");
    exit(1);
  }
  source_str = (char*)malloc(MAX_SOURCE_SIZE);
  source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
  source_str = (char*)realloc(source_str, source_size);
  fclose(fp);
  /* Get Platform and Device Info */
  ret = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
  ret = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);
  /* Create OpenCL context */
  context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &ret);
  /* Create Command Queue */
#if CL_TARGET_OPENCL_VERSION < 200
  command_queue = clCreateCommandQueue(context, device_id, 0, &ret);
#else
  command_queue = clCreateCommandQueueWithProperties(context, device_id, NULL, &ret);
#endif
  /* Create Memory Buffer */
  memobj = clCreateBuffer(context, CL_MEM_READ_WRITE, MEM_SIZE * sizeof(char), NULL, &ret);
  if (is_clsrc) {
    /* Create Kernel Program from the source */
    program = clCreateProgramWithSource(context, 1, (const char **)&source_str,(const size_t *)&source_size, &ret);
  } else {
    /* Create Kernel Program from the binary */
    program = clCreateProgramWithBinary(context, 1, &device_id, &source_size, (const unsigned char **)&source_str, NULL, &ret);
  }
  /* Build Kernel Program */
  ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
  if (is_clsrc) {
    /* Save binary kernel */
    size_t programBinarySize;
    clGetProgramInfo(program, CL_PROGRAM_BINARY_SIZES, sizeof(cl_device_id), &programBinarySize, NULL);
    char *programBinary = (char*)malloc(programBinarySize);
    clGetProgramInfo(program, CL_PROGRAM_BINARIES, sizeof(char *), &programBinary, NULL);
    fp = fopen("kernel.bin", "wb");
    fwrite(programBinary, 1, programBinarySize, fp);
    free(programBinary);
    fclose(fp);
  }
  /* Create OpenCL Kernel */
  kernel = clCreateKernel(program, "hello", &ret);
  /* Set OpenCL Kernel Parameters */
  ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&memobj);
  /* Execute OpenCL Kernel */
#if CL_TARGET_OPENCL_VERSION < 200
  ret = clEnqueueTask(command_queue, kernel, 0, NULL,NULL);
#else
  const size_t global_work_size[] = {1};
  const size_t local_work_size[] = {1};
  ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, global_work_size, local_work_size, 0, NULL, NULL);
#endif
  /* Copy results from the memory buffer */
  ret = clEnqueueReadBuffer(command_queue, memobj, CL_TRUE, 0,
    MEM_SIZE * sizeof(char),string, 0, NULL, NULL);
  /* Display Result */
  puts(string);
  /* Finalization */
  ret = clFlush(command_queue);
  ret = clFinish(command_queue);
  ret = clReleaseKernel(kernel);
  ret = clReleaseProgram(program);
  ret = clReleaseMemObject(memobj);
  ret = clReleaseCommandQueue(command_queue);
  ret = clReleaseContext(context);
  free(source_str);
  return ret;
}

int main(int argc, char *argv[]) {
  return cl_main(argc, argv);
}

