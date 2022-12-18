package;

import Engine;
import GraphicsAbstract;
import Graphics;
import lime.graphics.RenderContext;
import peote.view.Color;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import haxe.CallStack;
import lime.app.Application;
import lime.ui.Window;

class Main extends Application {
	override function onWindowCreate():Void {
		switch (window.context.type) {
			case WEBGL, OPENGL, OPENGLES:
				try
					startSample(window)
				catch (_)
					trace(CallStack.toString(CallStack.exceptionStack()), _);
			default:
				throw("Sorry, only works with OpenGL.");
		}
	}

	// ------------------------------------------------------------
	// --------------- SAMPLE STARTS HERE -------------------------
	// ------------------------------------------------------------
	
	public function startSample(window:Window) {
		Peote.init(window);

		var bounds_viewport:RectangleGeometry = {
			y: 0,
			x: 0,
			width: window.width,
			height: window.height
		}
		
		var bounds_scene:RectangleGeometry = {
			y: 0,
			x: 0,
			width: window.width,
			height: window.height
		}

		var black = 0x000000ff;
		var init_scene = game -> new SpaceScene(game, bounds_scene, black);

		var implementation_graphics:GraphicsConcrete = {
			viewport_bounds: bounds_viewport,
			make_polygon: (model, color) -> Peote.make_polygon(model, color),
			make_particle: (x, y, size, color, lifetime_seconds) -> Peote.make_particle(x, y, color, size, lifetime_seconds)
		}

		game = new Game(init_scene, implementation_graphics);

		@:privateAccess
		var scene:SpaceScene = cast game.current_scene;
		@:privateAccess
		ship = scene.ship;
		

		isReady = true;
	}

	// ------------------------------------------------------------
	// ----------------- LIME EVENTS ------------------------------
	// ------------------------------------------------------------

	override function onPreloadComplete():Void {
		// access embeded assets from here
	}

	override function onKeyDown(keyCode:KeyCode, modifier:KeyModifier) {
		super.onKeyDown(keyCode, modifier);
		
		switch keyCode {
			case DOWN: ship.set_acceleration(true);
			case UP: ship.set_brakes(true);
			case LEFT: ship.set_rotation_direction(-1);
			case RIGHT: ship.set_rotation_direction(1);
			case _: return;
		}
	}

	override function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
		super.onKeyUp(keyCode, modifier);
		switch keyCode {
			case DOWN: ship.set_acceleration(false);
			case UP: ship.set_brakes(false);
			case LEFT: ship.set_rotation_direction(0);
			case RIGHT: ship.set_rotation_direction(0);
			case _: return;
		}
	}

	override function update(deltaTime:Int):Void {
		if (!isReady) {
			return;
		}

		elapsed_seconds = deltaTime / 1000;
		time += elapsed_seconds;
		game.update(elapsed_seconds);
	}
	
	override function render(context:RenderContext) {
		super.render(context);
		game.draw();
		
		Peote.draw();
	}

	var isReady:Bool;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;

	var game:Game;

	var ship:Ship;
}