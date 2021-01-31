# General Python imports
import math
import numpy as np

# NoobQuant imports
from nqcolors import nq_colors, nq_textcolors

# manim imports
from manim.mobject.geometry import Circle, Square
from manim.constants import RIGHT, LEFT, UP, DOWN, ORIGIN
from manim.animation.creation import ShowCreation
from manim.animation.transform import Transform
from manim.animation.fading import FadeOut
from manim import config, Scene
from manim.scene.graph_scene import GraphScene
from manim.mobject.svg.tex_mobject import MathTex
from manim.mobject.types.vectorized_mobject import VGroup
from manim.mobject.probability import BarChart

# Acces global config, here change background colors
config.background_color = nq_colors["dark_blue"]

class SquareToCircle(Scene):
    """Very simple example to play with"""
    def construct(self):
        circle = Circle(color=nq_colors["purple"])
        circle.set_fill(nq_colors["purple"], opacity=0.5)

        square = Square(color=nq_colors["orange"])
        square.flip(RIGHT)
        square.rotate(-3 * 2*math.pi / 8)

        self.play(ShowCreation(square))
        self.play(Transform(square, circle))
        self.play(FadeOut(square))

class LinePlot(GraphScene):
    def __init__(self, **kwargs):
        GraphScene.__init__(
            self,
            x_min=0,
            x_max=12,
            y_min=-2,
            y_max=2,
            graph_origin=np.array((-5.0, 0.0, 0.0)),
            axes_color=nq_textcolors["white"],
            x_labeled_nums=range(0, 12, 2),
            **kwargs
        )

    def construct(self):

        # Setup axes and show their creation
        self.setup_axes(animate=True)

        # Get parametric curves
        func_graph = self.get_graph(np.cos, color=nq_colors["steelblue"])
        func_graph2 = self.get_graph(np.sin, color=nq_colors["light_purple"])
        
        # Get vetical line from x axis to first graph
        vert_line = self.get_vertical_line_to_graph(
            x=2*math.pi,
            graph=func_graph,
            color=nq_colors["orange"]
        )
        
        # Set label texts
        graph_lab = self.get_graph_label(func_graph, label="\\cos(x)", x_val=5, direction=UP/2)
        two_pi = MathTex(r"x = 2 \pi")

        # Get y-point from first line 
        label_coord = self.input_to_graph_point(
            x=2*math.pi,
            graph=func_graph
        )
        
        # Set label next to point we found
        two_pi.next_to(label_coord, RIGHT + UP)
        
        # Animate
        self.play(ShowCreation(func_graph), run_time=2)
        self.wait(0.2)
        self.play(ShowCreation(func_graph2), run_time=2)
        self.wait(1)
        self.play(ShowCreation(vert_line), run_time=1)
        self.add(func_graph2, graph_lab, two_pi)
        self.wait(3)
