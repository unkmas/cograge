#!/usr/bin/env ruby
##encoding: utf-8

require 'rubygems'
require 'opengl'
require 'yaml'

include Gl, Glu, Glut

class BezierCurves
  def initialize
    @ctrlpoints = YAML.load_file 'scene.yaml'

    glutInit
    glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE
    glutInitWindowSize 800, 600
    glutInitWindowPosition 100, 100
    glutCreateWindow "Computer graphics and geometry: Bezier curves (lab 2)"
    glutDisplayFunc method(:display).to_proc
    glutReshapeFunc method(:reshape).to_proc
    glutKeyboardFunc method(:keyboard).to_proc

    init_gl_window
    glutMainLoop
  end

  def init_gl_window
    glClearColor 0.0, 0.0, 0.0, 0
    glShadeModel GL_FLAT
    glMap1d(GL_MAP1_VERTEX_3, 0.0, 1.0, 3, 4, @ctrlpoints.flatten)
    glEnable(GL_MAP1_VERTEX_3)    
  end

  def display
    glClear GL_COLOR_BUFFER_BIT
    glColor 1.0, 1.0, 1.0
    glBegin GL_LINE_STRIP
    for i in 0..30
      glEvalCoord1d i / 30.0
    end
    glEnd
    glPointSize 5.0
    glColor 1.0, 1.0, 0.0
    glBegin GL_POINTS
    for i in 0...4
      glVertex @ctrlpoints[i]
    end
    glEnd
    glutSwapBuffers
  end
  private :display

  def reshape w, h
    glViewport 0, 0, w, h
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    if w <= h
      glOrtho -5.0, 5.0, -5.0 * h / w, 5.0 * h / w, -5.0, 5.0
    else
      glOrtho -5.0 * w / h, 5.0 * w / h, -5.0, 5.0, -5.0, 5.0
    end
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
  end
  private :reshape

  def keyboard key, x, y
    case (key)
    when ?\e
      exit(0)
    end
  end
  private :keyboard
end

BezierCurves.new