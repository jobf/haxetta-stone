package;

import lime.graphics.RenderContext;
import peote.view.Color;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import Peote;
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
		x_center = Std.int(window.width * 0.5);
		y_center = Std.int(window.height * 0.5);
		ship = new Ship(x_center, y_center);
		obstacle = new Asteroid(x_center + 100, y_center + 45);
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
		ship.update(elapsed_seconds);
		ship.set_color(obstacle.overlaps_polygon(ship.collision_points()) ? Color.RED : Color.WHITE);
		obstacle.update(elapsed_seconds);
	}
	
	override function render(context:RenderContext) {
		super.render(context);
		obstacle.draw();
		ship.draw();
		Peote.draw();
	}

	var isReady:Bool;
	var x_center:Int;
	var y_center:Int;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;

	var ship:Ship;

	var obstacle:Asteroid;
}