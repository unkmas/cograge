#!/usr/bin/env ruby

require 'rubygems'
require 'singleton'
require 'gl'
require 'glu'
require 'glut'

include Gl
include Glu
include Glut

class Lab
  include Singleton
  attr_reader :scene

  def initialize
    @zoom = 1.0
    @shift_x = 0.0
    @shift_y = 0.0
    @rotate_x = 0.0
    @rotate_y = 0.0
    @rotate_z = 0.0
    @trans = 0.0

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
    init_gl_window(800, 600)
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
  end

  def reshape w, h
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(40.0, w / h, 1.0, 20.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslate(0.0, 0.0, @trans);
  end

  def draw_gl_scene
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    # Reset the view
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity();
    glPushMatrix();
    glTranslate(0.0, 0.0, @trans - 3.0);

    # Translate scene
    glTranslatef(@shift_x, @shift_y, 0)
    glScalef(@zoom, @zoom, 1.0)

    # Rotate scene
    glRotatef(@rotate_x, 1.0, 0.0, 0.0)
    glRotatef(@rotate_y, 0.0, 1.0, 0.0)
    glRotatef(@rotate_z, 0.0, 0.0, 1.0)

    # Draw scene
    glBegin(GL_LINES)
      @scene.each do |v1, v2|
        glColor4fv(v1);
        glVertex4fv(v1);
        glColor4fv(v2);
        glVertex4fv(v2);
      end
    glEnd
    glPopMatrix();

    glutSwapBuffers;
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
      when ?w
        @shift_y += 0.05
      when ?a
        @shift_x -= 0.05
      when ?s
        @shift_y -= 0.05
      when ?d
        @shift_x += 0.05
      # y, u, h, j, n, m: rotate
      when ?y
        @rotate_x -= 1
      when ?u
        @rotate_x += 1
      when ?h
        @rotate_y -= 1
      when ?j
        @rotate_y += 1
      when ?n
        @rotate_z -= 1
      when ?m
        @rotate_z += 1
      # i, o: zoom in/out
      when ?i
        @zoom += 0.05
      when ?o
        @zoom -= 0.05
      # r, f: transformation
      when ?r
        @trans += 0.5
      when ?f
        @trans -= 0.5
      else
        p key
    end
    glutPostRedisplay
  end
end

puts <<EOF
  W, A, S, D       : translate
  Y, U, H, J, N, M : rotate
  I, O             : scale
  R, F             : transformation
EOF
Lab.instance
