require 'rubygems'
require 'opengl'
require 'mathn'
require 'singleton'

include Gl,Glu,Glut

class BezMesh
  include Singleton

  def initialize
    glutInit
    glutInitDisplayMode GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH
    glutInitWindowSize 500, 500
    glutInitWindowPosition 100, 100
    glutCreateWindow "Computer graphics and geometry: Bezier meshes (lab 3)"
    gl_init
    glutDisplayFunc method(:display).to_proc
    glutReshapeFunc method(:reshape).to_proc
    glutKeyboardFunc method(:keyboard).to_proc
    glutMainLoop
  end

  def gl_init
    mat_specular = [1.0, 1.0, 1.0, 1.0]
    light_position = [1.0, 1.0, 1.0, 0.0]
    diffuse_material = [0.5, 0.5, 0.5, 1.0]
    glClearColor 0.0, 0.0, 0.0, 0.0
    glShadeModel GL_SMOOTH
    glEnable GL_DEPTH_TEST
    glMaterial GL_FRONT, GL_DIFFUSE, diffuse_material
    glMaterial GL_FRONT, GL_SPECULAR, mat_specular
    glMaterial GL_FRONT, GL_SHININESS, 25.0
    glLight GL_LIGHT0, GL_POSITION, light_position
    glEnable GL_LIGHTING
    glEnable GL_LIGHT0
    glColorMaterial GL_FRONT, GL_DIFFUSE
    glEnable GL_COLOR_MATERIAL
  end
  private :gl_init

  def display
    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    glutSolidSphere 1.0, 20, 16
    glutSwapBuffers()
  end
  private :display

  def reshape w, h
    glViewport 0, 0,  w,  h
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    if  w <= h
      glOrtho -1.5, 1.5, -1.5 * h / w, 1.5 * h / w, -10.0, 10.0
    else
      glOrtho -1.5 * w / h, 1.5 * w / h, -1.5, 1.5, -10.0, 10.0
    end
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
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

BezMesh.instance