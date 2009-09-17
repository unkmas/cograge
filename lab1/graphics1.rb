#!/usr/bin/env ruby

require 'rubygems'
require 'gl'
require 'glu'
require 'glut'

include Gl
include Glu
include Glut

class Lab
  attr_reader :scene

  def initialize
    @zoom = 1.0
    @shift_x = 0.0
    @shift_y = 0.0
    @rotate = 0

    # Load and prepare verteces
    raw = YAML.load_file('scene.yaml')
    @scene = raw['topology'].map do |t1, t2|
      [ raw['verteces'][t1], raw['verteces'][t2] ]
    end

    # OpenGL and GLUT initialization
    glutInit;
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutInitWindowPosition(0, 0);
    @window = glutCreateWindow('Computer Graphics and Geometry: Lab 1');
    glutDisplayFunc(method(:draw_gl_scene).to_proc);
    glutReshapeFunc(method(:reshape).to_proc);
    glutIdleFunc(method(:idle).to_proc);
    glutKeyboardFunc(method(:keyboard).to_proc);
    init_gl_window(640, 480)
    glutMainLoop();
  end

  def init_gl_window w, h
    # Background color to black
    glClearColor(0.0, 0.0, 0.0, 0);
    # Enables clearing of depth buffer
    glClearDepth(1.0);
    # Set type of depth test
    glDepthFunc(GL_LEQUAL);
    # Enable depth testing
    glEnable(GL_DEPTH_TEST);
    # Enable smooth color shading
    glShadeModel(GL_SMOOTH);
  end

  def draw_gl_scene
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    # Reset the view
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity

    # Translate scene
    glTranslatef(@shift_x, @shift_y, 0.0)
    glScalef(@zoom, @zoom, 1.0)

    # Rotate scene on the Z-axis
    glRotatef(@rotate, 0.0, 0.0, 1.0)

    # Draw scene
    glBegin(GL_LINES)
      @scene.each do |v1, v2|
        glColor4fv(v1);
        glVertex4fv(v1);
        glColor4fv(v2);
        glVertex4fv(v2);
      end
    glEnd

    glutSwapBuffers;
  end

  def reshape w, h
    h = 1 if h == 0
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if (w <= h)
      glOrtho(-1.5, 1.5, -1.5 * h/w, 1.5 * h/w, -10.0, 10.0);
    else
      glOrtho(-1.5 * w/h, 1.5 * w/h, -1.5, 1.5, -10.0, 10.0);
    end
    glMatrixMode(GL_MODELVIEW);
  end

  def idle
    glutPostRedisplay;
  end

  def keyboard key, x, y
    case(key)
      # esc: exit
      when ?\e
        glutDestroyWindow(@window)
        exit 0
      # w, a, s, d: translate
      when 119 # w
        @shift_y += 0.05
      when 97 # a
        @shift_x -= 0.05
      when 115  # s
        @shift_y -= 0.05
      when 100 # d
        @shift_x += 0.05
      # q, e: rotate
      when 113 # q
        @rotate -= 1
      when 101 # e
        @rotate += 1
      # i, o: zoom in/out
      when 105
        @zoom += 0.05
      when 111
        @zoom -= 0.05
      else
        p key
    end
    glutPostRedisplay
  end
end

puts <<EOF
  W, A, S, D : translate
  Q, E       : rotate
  I, O       : scale
EOF
Lab.new
