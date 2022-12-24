## What the haxe?

Haxe has many options for putting pixels on the screen, handling input, etc.

This project aims to use a single core codebase for logic and abstracted systems for everything else.

Multiple frameworks will provide alternate implementations for the systems, currently graphics and keyboard input;

## Implementations

See directories for framework implementations

### [/peoteview/readme.md](peoteview)/

OpenGL abstraction layer for fast 2d-rendering on lime - https://github.com/openfl/lime/

### [/raylibhx/readme.md](raylibhx)/

raylib externs (small OpenGL drawing toolkit in c) - https://github.com/raysan5/raylib

### [/flixel/readme.md](flixel)/

OpenFL based game engine (also lime) - https://github.com/HaxeFlixel/flixel

## The Game

It's asteroids, you have a ship that can be controller with cursor keys 

 - 🠔 : rotate the ship left
 - 🠔 : rotate the ship right
 - 🠗 : accelerate the ship