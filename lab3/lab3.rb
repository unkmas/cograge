#!/usr/bin/env ruby
#encoding: utf-8

require 'rubygems'
require 'opengl'

include Gl, Glu, Glut

class BezierMeshes
  def initialize
    @ctrlpoints = YAML.load_file "scene.yaml"
    glutInit()
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
    glutInitWindowSize(500, 500)
    glutInitWindowPosition(100, 100)
    glutCreateWindow($0)
    gl_init()
    glutReshapeFunc(method(:reshape).to_proc)
    glutDisplayFunc(method(:display).to_proc)
    glutKeyboardFunc(method(:keyboard).to_proc)
    glutMainLoop()
  end

  def initlights
    ambient = [0.2, 0.2, 0.2, 1.0]
    position = [0.0, 0.0, 2.0, 1.0]
    mat_diffuse = [0.6, 0.6, 0.6, 1.0]
    mat_specular = [1.0, 1.0, 1.0, 1.0]
    mat_shininess = [50.0]

    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)

    glLight(GL_LIGHT0, GL_AMBIENT, ambient)
    glLight(GL_LIGHT0, GL_POSITION, position)

    glMaterial(GL_FRONT, GL_DIFFUSE, mat_diffuse)
    glMaterial(GL_FRONT, GL_SPECULAR, mat_specular)
    glMaterial(GL_FRONT, GL_SHININESS, mat_shininess)
  end
  private :initlights

  def display
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glPushMatrix()
    glRotate(85.0, 1.0, 1.0, 1.0)
    glEvalMesh2(GL_FILL, 0, 20, 0, 20)
    glPopMatrix()
    glutSwapBuffers()
  end
  private :display

  def reshape w, h
    glViewport(0, 0, w, h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    if (w <= h)
      glOrtho(-4.0, 4.0, -4.0 * h / w, 4.0 * h / w, -4.0, 4.0)
    else
      glOrtho(-4.0 * w / h, 4.0 * w / h, -4.0, 4.0, -4.0, 4.0)
    end
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
  end
  private :reshape

  def keyboard key, x, y
    case (key)
    when ?\e
      exit(0);
    end
  end
  private :keyboard

  def gl_init
    glClearColor(0.0, 0.0, 0.0, 1.0)
    glEnable(GL_DEPTH_TEST)
    glMap2d(GL_MAP2_VERTEX_3, 0, 1, 3, 4, 0, 1, 12, 4, @ctrlpoints.flatten)
    glEnable(GL_MAP2_VERTEX_3)
    glEnable(GL_AUTO_NORMAL)
    glEnable(GL_NORMALIZE)
    glMapGrid2d(20, 0.0, 1.0, 20, 0.0, 1.0)
    initlights()
  end
  private :gl_init
end

BezierMeshes.new