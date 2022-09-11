#include <iostream>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/videodev2.h>
#include <linux/media.h>
#include <unistd.h>
#include <string.h>
#include <vector>

struct bufinfo{
  uint8_t *start;
  uint32_t length;
};
int main(int argc, char *argv[]) {
  //enum entity
  const char *path = "/dev/media0";
  if (argc > 1)
    path = argv[1];
  int mediafd = open(path, O_RDWR, 0);
  struct media_entity_desc entity;
  entity.id = 0 | MEDIA_ENT_ID_FLAG_NEXT;
  char videopath[64] = {0};
  while(!ioctl(mediafd, MEDIA_IOC_ENUM_ENTITIES, &entity)) {
    printf("%s: %u\n", entity.name, entity.type);
    if (MEDIA_ENT_T_V4L2_SUBDEV_SENSOR == entity.type)
      snprintf(videopath, sizeof(videopath), "/dev/video%u", entity.group_id);
    entity.id |= MEDIA_ENT_ID_FLAG_NEXT;
  }
  close(mediafd);
  //open camera
  int devfd = open(videopath, O_RDWR, 0);
  //get vendortag
  struct v4l2_capability cap;
  ioctl(devfd, VIDIOC_QUERYCAP, &cap);
  printf("cap: 0x%x\n", cap.capabilities);
  struct v4l2_input input;
  input.index = 0;
  while(!ioctl(devfd, VIDIOC_ENUMINPUT, &input)) {
    printf("%s std: 0x%08llx\n", input.name, input.std);
    input.index++;
  }
  struct v4l2_fmtdesc fmtd;
  fmtd.index = 0;
  fmtd.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  while(!ioctl(devfd, VIDIOC_ENUM_FMT, &fmtd)) {
    printf("fmt: %s %u\n", fmtd.description, fmtd.pixelformat);
    struct v4l2_frmsizeenum sizee;
    sizee.index = 0;
    sizee.pixel_format = fmtd.pixelformat;
    while(!ioctl(devfd, VIDIOC_ENUM_FRAMESIZES, &sizee)) {
      if (V4L2_FRMSIZE_TYPE_DISCRETE == sizee.type)
        printf("size: %ux%u\n", sizee.discrete.width, sizee.discrete.height);
      sizee.index++;
    }
    fmtd.index++;
  }
  //set config
  int sinput = 0;
  ioctl(devfd, VIDIOC_S_INPUT, &input);
  struct v4l2_format fmt;
  memset(&fmt, 0, sizeof(fmt));
  fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  fmt.fmt.pix.width = 640;
  fmt.fmt.pix.height = 480;
  fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
  fmt.fmt.pix.field = V4L2_FIELD_ANY;
  ioctl(devfd, VIDIOC_S_FMT, &fmt);
  ioctl(devfd, VIDIOC_G_FMT, &fmt);
  printf("field: %u\n", fmt.fmt.pix.field);
  //prepare buf
  constexpr int bufcnt = 5;
  struct v4l2_requestbuffers req;
  req.count = bufcnt;
  req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  req.memory = V4L2_MEMORY_MMAP;
  ioctl(devfd, VIDIOC_REQBUFS, &req);
  struct v4l2_buffer capture_buf;
  std::vector<bufinfo> bufs(bufcnt);
  for(int i=0;i<bufcnt;i++) {
    capture_buf.type = req.type;
    capture_buf.memory = req.memory;
    capture_buf.index = i;
    ioctl(devfd, VIDIOC_QUERYBUF, &capture_buf);
    bufs[i].length = capture_buf.length;
    bufs[i].start = static_cast<uint8_t*>(mmap(NULL, bufs[i].length, PROT_READ, MAP_SHARED, devfd, capture_buf.m.offset));
    ioctl(devfd, VIDIOC_QBUF, &capture_buf);
  }
  //stream on
  ioctl(devfd, VIDIOC_STREAMON, &req.type);
  //save img
  char savepath[64];
  for(int i=0;i<bufcnt*2;i++) {
    memset(&capture_buf, 0, sizeof(capture_buf));
    capture_buf.type = req.type;
    capture_buf.memory = req.memory;
    ioctl(devfd, VIDIOC_DQBUF, &capture_buf);
    snprintf(savepath, sizeof(savepath), "%d.yuv", i);
    int savefd = open(savepath, O_RDWR|O_CREAT, 0644);
    write(savefd, bufs[capture_buf.index].start, bufs[capture_buf.index].length);
    close(savefd);
    ioctl(devfd, VIDIOC_QBUF, &capture_buf);
  }
  //stream off
  ioctl(devfd, VIDIOC_STREAMOFF, &req.type);
  //release buf
  for(int i=0;i<bufcnt;i++)
    munmap(bufs[i].start, bufs[i].length);
  //close camera
  close(devfd);
  return 0;
}
