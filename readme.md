## What the haxe?

Haxe has many options for putting pixels on the screen, handling input, etc.

This project aims to use a single core codebase for logic and abstracted systems for everything else.

Multiple frameworks will provide alternate implementations for the systems, currently graphics and keyboard input;

## Implementations

See directories for framework implementations

### peoteview/

Low level macro driven OpenGL abstractions over Lime Application Framework - https://github.com/maitag/peote-view

### raylibhx/

C based OpenGL via raylib hxcpp bindings - https://github.com/foreignsasquatch/raylib-hx

### flixel/

High level 2D game framework over OpenFL (also Lime Application Framework) - https://github.com/HaxeFlixel/flixel

## The Game

It's asteroids, you have a ship that can be controller with cursor keys 

 - 🠔 : rotate the ship left
 - 🠔 : rotate the ship right
 - 🠗 : accelerate the ship