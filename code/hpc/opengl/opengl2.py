from OpenGL import GL as gl
import glfw
import numpy as np
import ctypes
import time

class button:
  def __init__(self, x=0, y=0, w=320, h=240, t="button"):
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.created = False
    self.vertexShaderSource = \
    '''
    layout (location = 0) in vec3 aPos;
    layout (location = 1) in vec3 aCol;
    out vec3 ourcolor;
    void main() {
      gl_Position = vec4(aPos, 1.0);
      ourcolor = aCol;
    }
    '''
    self.fragmentShaderSource = \
    '''
    out vec4 FragColor;
    in vec3 ourcolor;
    void main() {
      FragColor = vec4(ourcolor, 1.0);
    }
    '''
    self.indices = np.array([
    0, 1, 3,
    1, 2, 3
    ], dtype=np.int32)
  def create(self):
    self.shaderProgram = self.create_program(self.vertexShaderSource, self.fragmentShaderSource)
    self.bind_buffer()
  def create_program(self, vertex, fragment):
    vertexShader = gl.glCreateShader(gl.GL_VERTEX_SHADER)
    gl.glShaderSource(vertexShader, [vertex])
    gl.glCompileShader(vertexShader)
    fragmentShader = gl.glCreateShader(gl.GL_FRAGMENT_SHADER)
    gl.glShaderSource(fragmentShader, [fragment])
    gl.glCompileShader(fragmentShader)
    shaderProgram = gl.glCreateProgram()
    gl.glAttachShader(shaderProgram, vertexShader)
    gl.glAttachShader(shaderProgram, fragmentShader)
    gl.glLinkProgram(shaderProgram)
    gl.glDeleteShader(vertexShader)
    gl.glDeleteShader(fragmentShader)
    return shaderProgram
  def bind_buffer(self):
    self.VAO = gl.glGenVertexArrays(1)
    self.VBO = gl.glGenBuffers(1)
    self.EBO = gl.glGenBuffers(1)
    gl.glBindVertexArray(self.VAO)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.VBO)
    gl.glBufferData(gl.GL_ARRAY_BUFFER, self.vertices.nbytes, self.vertices, gl.GL_STATIC_DRAW)
    gl.glEnableVertexAttribArray(0)
    gl.glVertexAttribPointer(0, 3, gl.GL_FLOAT, gl.GL_FALSE, self.vertices.dtype.itemsize * 6, ctypes.c_voidp(0))
    gl.glEnableVertexAttribArray(1)
    gl.glVertexAttribPointer(1, 3, gl.GL_FLOAT, gl.GL_FALSE, self.vertices.dtype.itemsize * 6, ctypes.c_voidp(self.vertices.dtype.itemsize * 3))
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.EBO)
    gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, self.indices.nbytes, self.indices, gl.GL_STATIC_DRAW)
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, 0)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, 0)
    gl.glBindVertexArray(0)
  def draw(self):
    if not self.created:
      self.create()
    gl.glUseProgram(self.shaderProgram)
    gl.glBindVertexArray(self.VAO)
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.EBO)
    gl.glDrawElements(gl.GL_TRIANGLES, 6, gl.GL_UNSIGNED_INT, None)
  def update(self, wscale, hscale):
    self.vertices = np.array([
    self.x + wscale,  self.y + hscale, 0.0, 1.0, 0.0, 0.0,
    self.x + wscale, self.y - hscale, 0.0, 0.0, 1.0, 0.0,
    self.x - wscale, self.y - hscale, 0.0, 0.0, 0.0, 1.0,
    self.x - wscale,  self.y + hscale, 0.0, 0.5, 0.5, 5.0,
    ], dtype= np.float32);
  def on_click(self, x, y):
    if x > self.vertices[12] and x < self.vertices[0] and y > self.vertices[13] and y < self.vertices[1]:
      print(self.t + " clicked")
  def __del__(self):
    if self.created:
      gl.glDeleteVertexArrays(1, [self.VAO])
      gl.glDeleteBuffers(2, [self.VBO, self.EBO])
      gl.glDeleteProgram(self.shaderProgram)

g_view = None
class view:
  @staticmethod
  def framebuffer_size_callback(window, width, height):
    gl.glViewport(0, 0, width, height)
    g_view.w = width
    g_view.h = height
    for i in g_view.l:
      wscale = i.w/g_view.w
      hscale = i.h/g_view.h
      i.update(wscale, hscale)
  @staticmethod
  def mouse_button_callback(window, button, action, mods):
    if (button == glfw.MOUSE_BUTTON_LEFT and action == glfw.PRESS):
      p = glfw.get_cursor_pos(window)
      x = p[0] /(g_view.w/2) - 1
      y = 1 - p[1] /(g_view.h/2)
      for i in g_view.l:
        i.on_click(x, y)
      #print(p)
  def __init__(self, w=640, h=480, t="Hello World"):
    self.w = w
    self.h = h
    self.t = t
    self.l = []
    glfw.init()
    self.window = glfw.create_window(self.w, self.h, self.t, None, None)
    glfw.set_framebuffer_size_callback(self.window, view.framebuffer_size_callback)
    glfw.set_mouse_button_callback(self.window, view.mouse_button_callback)
    glfw.make_context_current(self.window)
  def add(self, item):
    self.l.append(item)
    wscale = item.w/self.w
    hscale = item.h/self.h
    item.update(wscale, hscale)
  def run(self):
    while not glfw.window_should_close(self.window):
      gl.glClear(gl.GL_COLOR_BUFFER_BIT)
      for i in self.l:
        i.draw()
      glfw.swap_buffers(self.window)
      glfw.poll_events()
      time.sleep(1/30)
    glfw.terminate()
  def __del__(self):
    for i in self.l:
      del i

V = view()
B = button(w=240)
V.add(B)
B2 = button(x=0.5, y=0.5, t="button2")
V.add(B2)
g_view = V
V.run()