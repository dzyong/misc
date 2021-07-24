#ifndef CALLBACK
#define CALLBACK
#endif
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <unistd.h>
#include <stdio.h>
int main(void) {
  GLFWwindow* window;
  glfwInit();
  window = glfwCreateWindow(480, 320, "Hello World", NULL, NULL);
  glfwMakeContextCurrent(window);
  glewInit();
  GLfloat vertices[] = {
    0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f,
    -1.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f,
    1.0f, -1.0f, 0.0f, 0.0f, 0.0f, 1.0f
  };
  GLuint VAOId, VBOId;
  glGenVertexArrays(1, &VAOId);
  glBindVertexArray(VAOId);
  glGenBuffers(1, &VBOId);
  glBindBuffer(GL_ARRAY_BUFFER, VBOId);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GL_FLOAT), (GLvoid*)0);
  glEnableVertexAttribArray(0);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GL_FLOAT), (GLvoid*)(3 * sizeof(GL_FLOAT)));
  glEnableVertexAttribArray(1);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);
  const GLchar* vertexShaderSource = "#version 460\n \
                                      layout(location = 0) in vec3 position; \
                                      layout(location = 1) in vec3 color; \
                                      out vec3 vertColor; \
                                      void main(){ \
                                        gl_Position = vec4(position, 1.0); \
                                          vertColor = color; \
                                      }";
  GLuint vertexShaderId = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertexShaderId, 1, &vertexShaderSource, NULL);
  glCompileShader(vertexShaderId);
  const GLchar* fragShaderSource = "#version 460\n \
                                    in vec3 vertColor; \
                                    out vec4 color; \
                                    void main(){ \
                                      color = vec4(vertColor, 1.0); \
                                    }";
  GLuint fragShaderId = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragShaderId, 1, &fragShaderSource, NULL);
  glCompileShader(fragShaderId);
  GLuint shaderProgramId = glCreateProgram();
  glAttachShader(shaderProgramId, vertexShaderId);
  glAttachShader(shaderProgramId, fragShaderId);
  glLinkProgram(shaderProgramId);
  glDetachShader(shaderProgramId, vertexShaderId);
  glDetachShader(shaderProgramId, fragShaderId);
  glDeleteShader(vertexShaderId);
  glDeleteShader(fragShaderId);
  glBindVertexArray(VAOId);
  glUseProgram(shaderProgramId);
  while (!glfwWindowShouldClose(window)) {
    int width, height;
    glfwGetWindowSize(window, &width, &height);
    glViewport(0, 0, width, height);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glfwSwapBuffers(window);
    glfwWaitEvents();
    glClear(GL_COLOR_BUFFER_BIT);
  }
  glfwTerminate();
  return 0;
}
