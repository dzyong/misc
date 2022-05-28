from OpenGL import GL as gl
import glfw
import numpy as np
import ctypes
import time
import freetype
import copy
import gc
import sys

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
    self.VBO = None
  def create(self):
    self.shaderProgram = self.create_program(self.vertexShaderSource, self.fragmentShaderSource)
    self.bind_buffer()
    self.created = True
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
    gl.glBufferData(gl.GL_ARRAY_BUFFER, self.vertices.nbytes, self.vertices, gl.GL_DYNAMIC_DRAW)
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
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, 0)
    gl.glBindVertexArray(0)
  def update(self, wscale, hscale):
    self.vertices = np.array([
    self.x + wscale,  self.y + hscale, 0.0, 1.0, 0.0, 0.0,
    self.x + wscale, self.y - hscale, 0.0, 0.0, 1.0, 0.0,
    self.x - wscale, self.y - hscale, 0.0, 0.0, 0.0, 1.0,
    self.x - wscale,  self.y + hscale, 0.0, 0.5, 0.5, 5.0,
    ], dtype= np.float32);
    if self.VBO:
      gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.VBO)
      gl.glBufferData(gl.GL_ARRAY_BUFFER, self.vertices.nbytes, self.vertices, gl.GL_DYNAMIC_DRAW)
      gl.glBindBuffer(gl.GL_ARRAY_BUFFER, 0)
  def on_click(self, x, y):
    if x > self.vertices[12] and x < self.vertices[0] and y > self.vertices[13] and y < self.vertices[1]:
      print(self.t + " clicked")
      return True
  def __del__(self):
    if self.created:
      gl.glDeleteVertexArrays(1, [self.VAO])
      gl.glDeleteBuffers(2, [self.VBO, self.EBO])
      gl.glDeleteProgram(self.shaderProgram)

g_view = None
class bitmap:
  def __init__(self, w, r,b):
    self.width = w
    self.rows = r
    self.buffer = copy.copy(b)
class glyph:
  def __init__(self, bitmap_top, bitmap_left, advancex):
    self.bitmap_top = bitmap_top
    self.bitmap_left = bitmap_left
    class advance:
      def __init__(self, x):
        self.x = x
    self.advance = advance(advancex)
class view:
  @staticmethod
  def exit():
    glfw.terminate()
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
        if i.on_click(x, y):
          g_view.logcnt += 1
      g_view.str2buf("Clicked: " + str(g_view.logcnt))
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
    self.logcnt = 0
    self.logTexture = gl.glGenTextures(1)
    gl.glBindTexture(gl.GL_TEXTURE_2D, self.logTexture)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP_TO_BORDER)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP_TO_BORDER)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR);
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR);
    self.vertexShaderSource = \
    '''
    layout (location = 0) in vec4 vertex;
    out vec2 TexCoords;
    void main() {
      gl_Position = vec4(vertex.xy, 0.0, 1.0);
      TexCoords = vertex.zw;
    }
    '''
    self.fragmentShaderSource = \
    '''
    out vec4 FragColor;
    in vec2 TexCoords;
    uniform sampler2D text;
    void main() {
      FragColor = vec4(1.0, 1.0, 1.0, texture(text, vec2(TexCoords.s, 1.0 - TexCoords.t)).r);
    }
    '''
    self.shaderProgram = self.create_program(self.vertexShaderSource, self.fragmentShaderSource)
    gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, 1);
    gl.glEnable(gl.GL_BLEND)
    gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
    self.face = freetype.Face("C:\\Windows\\Fonts\\simsun.ttc")
    self.face.set_char_size(32*64)
    self.bitmaps = []
    self.glyphs = []
    self.bitmapbuffer = None
    self.str2buf("Clicked: ")
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
  def str2buf(self, s):
    s = s.strip()
    self.bitmaps.clear()
    self.glyphs.clear()
    total_length = 0
    max_y = 0
    min_y = 0
    for i in range(len(s)):
      self.face.load_char(s[i])
      tbitmap = self.face.glyph.bitmap
      self.bitmaps.append(bitmap(tbitmap.width, tbitmap.rows, tbitmap.buffer))
      self.glyphs.append(glyph(self.face.glyph.bitmap_top,self.face.glyph.bitmap_left, self.face.glyph.advance.x))
      total_length += (tbitmap.width + self.face.glyph.bitmap_left)
      max_y = max_y if max_y > self.face.glyph.bitmap_top else self.face.glyph.bitmap_top
      min_y = min_y if min_y > (tbitmap.rows - self.face.glyph.bitmap_top) else (tbitmap.rows - self.face.glyph.bitmap_top)
    self.bitmapbuffer = np.zeros((max_y+min_y, total_length), dtype=np.uint8)
    for i in range(max_y+min_y):
      offset = 0
      for j in range(len(s)):
        '''
        if i < self.glyphs[j].bitmap_top and i >  (self.bitmaps[j].rows - self.glyphs[j].bitmap_top):
          self.bitmapbuffer[i][offset+self.glyphs[j].bitmap_left:offset+self.glyphs[j].bitmap_left+self.bitmaps[j].width] = self.bitmaps[j].buffer[i*self.bitmaps[j].width:(i+1)*self.bitmaps[j].width]
        '''
        index = i - (max_y+min_y - self.bitmaps[j].rows)
        if index >= 0:
          self.bitmapbuffer[i][offset+self.glyphs[j].bitmap_left:offset+self.glyphs[j].bitmap_left+self.bitmaps[j].width] = self.bitmaps[j].buffer[index*self.bitmaps[j].width:(index+1)*self.bitmaps[j].width]
        offset += (self.bitmaps[j].width + self.glyphs[j].bitmap_left)
    gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RED, total_length, max_y+min_y, 0, gl.GL_RED, gl.GL_UNSIGNED_BYTE, self.bitmapbuffer)
    cs = 0.05
    cl = cs * len(s)
    self.click_vertices = np.array([
    cl - 1.0, 1.0, 1.0, 1.0,
    cl - 1.0, 1.0 - cs, 1.0, 0.0,
    -1.0, 1.0 - cs, 0.0, 0.0,
    -1.0, 1.0, 0.0, 1.0], dtype=np.float32)
    self.click_VAO = gl.glGenVertexArrays(1)
    self.click_VBO = gl.glGenBuffers(1)
    self.click_EBO = gl.glGenBuffers(1)
    gl.glBindVertexArray(self.click_VAO)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.click_VBO)
    gl.glBufferData(gl.GL_ARRAY_BUFFER, self.click_vertices.nbytes, self.click_vertices, gl.GL_DYNAMIC_DRAW)
    gl.glEnableVertexAttribArray(0)
    gl.glVertexAttribPointer(0, 4, gl.GL_FLOAT, gl.GL_FALSE, self.click_vertices.dtype.itemsize * 4, ctypes.c_voidp(0))
    self.click_indices = np.array([
    0, 1, 3,
    1, 2, 3
    ], dtype=np.int32)
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.click_EBO)
    gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, self.click_indices.nbytes, self.click_indices, gl.GL_STATIC_DRAW)
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, 0)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, 0)
    gl.glBindVertexArray(0)
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
      gl.glUseProgram(self.shaderProgram)
      gl.glBindVertexArray(self.click_VAO)
      gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.click_EBO)
      gl.glDrawElements(gl.GL_TRIANGLES, 6, gl.GL_UNSIGNED_INT, None)
      gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, 0)
      gl.glBindVertexArray(0)
      glfw.swap_buffers(self.window)
      glfw.poll_events()
      time.sleep(1/30)
  def __del__(self):
    gl.glDeleteTextures([self.logTexture])
    gl.glDeleteVertexArrays(1, [self.click_VAO])
    gl.glDeleteBuffers(2, [self.click_VBO, self.click_EBO])
    gl.glDeleteProgram(self.shaderProgram)
    for i in self.l:
      i = None

V = view()
B = button(w=240)
V.add(B)
B2 = button(x=0.5, y=0.5, t="button2")
V.add(B2)
g_view = V
V.run()
B = None
B2 = None
V = None
g_view = None
view.exit()