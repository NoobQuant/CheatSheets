# Links
 - [Manim Community webapge](https://docs.manim.community/en/v0.2.0/)
 - [Manim community repos](https://github.com/ManimCommunity)
 - [manim repo (community)](https://github.com/ManimCommunity/manim)
 - [Flowchart](https://github.com/manim-kindergarten/manim_sandbox/blob/master/docs/manim%E7%B1%BB%E7%BB%93%E6%9E%84.pdf) (from manim-kindergarten) 

# Installation (manim community)
Works well with pip install as described [here](https://docs.manim.community/en/v0.2.0/installation.html#installing-manim).

# Using

## Command line

Calling from command line:

```
manim myfile.py MyScene <tags>
```

Tags:
 - all tags [here](https://docs.manim.community/en/latest/tutorials/configuration.html#a-list-of-all-cli-flags)
 -`-p`: autoplay after rendering
 -`-s`: skip to the end and just show the final frame
 -`-f`: show the file in the file browser
 -`-n <number>`: skip ahead no nth animation of a scene

# General about manim

 - In *manim/constants.py*, e.g. `RIGHT` is a three-alement numpy array `np.array((1.0, 0.0, 0.0))`
