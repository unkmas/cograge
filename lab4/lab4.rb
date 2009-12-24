#!/usr/bin/env ruby

require 'rubygems'
require 'opengl'
require 'mathn'
require 'singleton'
include Gl, Glu, Glut

class AlphaChannel
  include Singleton

  def initialize
    glutInit
    glutInitDisplayMode GLUT_DOUBLE | GLUT_RGB
    glutInitWindowSize 500, 500
    glutInitWindowPosition 100, 100
    glutCreateWindow "Computer graphics and geometry: Z-buffer (lab 4)"
    init
    glutReshapeFunc method(:reshape).to_proc
    glutKeyboardFunc method(:keyboard).to_proc
    glutDisplayFunc method(:display).to_proc
    glutMainLoop
  end

  def init
    glEnable GL_BLEND
    glBlendFunc GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
    glShadeModel GL_FLAT
    glClearColor 0.0, 0.0, 0.0, 0.0
  end
  private :init

  def draw_left_triangle
    glBegin GL_TRIANGLES
    glColor 1.0, 1.0, 1.0, 0.75
    glVertex 0.1, 0.9, 0.0
    glVertex 0.1, 0.1, 0.0
    glVertex 0.7, 0.5, 0.0
    glEnd
  end
  private :draw_left_triangle

  def draw_right_triangle
    glBegin GL_TRIANGLES
    glColor 1.0, 1.0, 1.0, 0.75
    glVertex 0.9, 0.9, 0.0
    glVertex 0.3, 0.5, 0.0
    glVertex 0.9, 0.1, 0.0
    glEnd
  end
  private :draw_right_triangle

  def display
    glClear GL_COLOR_BUFFER_BIT
    draw_left_triangle
    draw_right_triangle
    glutSwapBuffers
  end
  private :display

  def reshape w, h
    glViewport 0, 0, w, h
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    if w <= h
      gluOrtho2D 0.0, 1.0, 0.0, 1.0 * h / w
    else
      gluOrtho2D 0.0, 1.0 * w / h, 0.0, 1.0
    end
  end
  private :reshape

  def keyboard key, x, y
    case key
    when ?\e
      exit 0
    end
  end
  private :keyboard
end

AlphaChannel.instance