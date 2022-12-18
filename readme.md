## What the haxe?

Haxe has many options for putting pixels on the screen, handling input, etc.

This project aims to use a single core codebase for logic and abstracted systems for everything else.

Multiple frameworks will provide alternate implementations for the systems, currently graphics and keyboard input;

## Implementations

See directories for framework implementations

 - peoteview : uses Peote View (OpenGL via Lime Application Framework) - https://github.com/maitag/peote-view
 - raylibhx : uses raylib-hx (OpenGL via raylib externs) https://github.com/foreignsasquatch/raylib-hx

## The Game

It's asteroids, you have a ship that can be controller with cursor keys 

 - 🠔 : rotate the ship left
 - 🠔 : rotate the ship right
 - 🠗 : accelerate the ship