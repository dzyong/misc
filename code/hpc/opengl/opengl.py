from OpenGL import GL as gl
import glfw
import numpy as np
import ctypes

vertexShaderSource = \
'''
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aCol;
out vec3 ourcolor;
void main() {
  gl_Position = vec4(aPos, 1.0);
  ourcolor = aCol;
}
'''
fragmentShaderSource = \
'''
out vec4 FragColor;
in vec3 ourcolor;
void main() {
  FragColor = vec4(ourcolor, 1.0);
}
 '''
vertices = np.array([
    0.5,  0.5, 0.0, 1.0, 0.0, 0.0,
    0.5, -0.5, 0.0, 0.0, 1.0, 0.0,
    -0.5, -0.5, 0.0, 0.0, 0.0, 1.0,
    -0.5,  0.5, 0.0, 0.5, 0.5, 5.0,
], dtype= np.float32);
indices = np.array([
    0, 1, 3,
    1, 2, 3
], dtype=np.int32)

def framebuffer_size_callback(window, width, height):
  gl.glViewport(0, 0, width, height);

glfw.init()
window = glfw.create_window(640, 480, "Hello World", None, None)
glfw.set_framebuffer_size_callback(window, framebuffer_size_callback)
glfw.make_context_current(window)

vertexShader = gl.glCreateShader(gl.GL_VERTEX_SHADER)
gl.glShaderSource(vertexShader, [vertexShaderSource])
gl.glCompileShader(vertexShader)
fragmentShader = gl.glCreateShader(gl.GL_FRAGMENT_SHADER)
gl.glShaderSource(fragmentShader, [fragmentShaderSource])
gl.glCompileShader(fragmentShader)
shaderProgram = gl.glCreateProgram()
gl.glAttachShader(shaderProgram, vertexShader)
gl.glAttachShader(shaderProgram, fragmentShader)
gl.glLinkProgram(shaderProgram)
gl.glDeleteShader(vertexShader)
gl.glDeleteShader(fragmentShader)
VAO = gl.glGenVertexArrays(1)
VBO = gl.glGenBuffers(1)
EBO = gl.glGenBuffers(1)
gl.glBindVertexArray(VAO)
gl.glBindBuffer(gl.GL_ARRAY_BUFFER, VBO)
gl.glBufferData(gl.GL_ARRAY_BUFFER, vertices.nbytes, vertices, gl.GL_STATIC_DRAW)
gl.glEnableVertexAttribArray(0)
gl.glVertexAttribPointer(0, 3, gl.GL_FLOAT, gl.GL_FALSE, vertices.dtype.itemsize * 6, ctypes.c_voidp(0))
gl.glEnableVertexAttribArray(1)
gl.glVertexAttribPointer(1, 3, gl.GL_FLOAT, gl.GL_FALSE, vertices.dtype.itemsize * 6, ctypes.c_voidp(vertices.dtype.itemsize * 3))
gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, EBO)
gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, indices.nbytes, indices, gl.GL_STATIC_DRAW)
gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, 0)
gl.glBindBuffer(gl.GL_ARRAY_BUFFER, 0)
gl.glBindVertexArray(0)

while not glfw.window_should_close(window):
  gl.glUseProgram(shaderProgram)
  gl.glBindVertexArray(VAO)
  gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, EBO)
  gl.glClear(gl.GL_COLOR_BUFFER_BIT)
  gl.glDrawElements(gl.GL_TRIANGLES, 6, gl.GL_UNSIGNED_INT, None)
  glfw.swap_buffers(window)
  glfw.poll_events()
gl.glDeleteVertexArrays(1, [VAO])
gl.glDeleteBuffers(2, [VBO, EBO])
gl.glDeleteProgram(shaderProgram)
glfw.terminate()