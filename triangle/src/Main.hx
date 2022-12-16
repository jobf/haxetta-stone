package;

import Peote;
import Geometry;
import haxe.CallStack;
import lime.app.Application;
import lime.ui.Window;
import peote.view.Color;

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
		triangle = new IsoscelesModel();
		polygon = Peote.make_polygon(triangle.points, Color.GREEN);
		x_center = window.width * 0.5;
		y_center = window.height * 0.5;
		isReady = true;
	}

	// ------------------------------------------------------------
	// ----------------- LIME EVENTS ------------------------------
	// ------------------------------------------------------------

	override function onPreloadComplete():Void {
		// access embeded assets from here
	}


	override function update(deltaTime:Int):Void {
		if (!isReady) {
			return;
		}

		elapsed_seconds = deltaTime / 1000;
		time += elapsed_seconds;

		// occasionally increase the rotation
		if (Std.int(time * 60) % 3 == 0) {
			rotation += 0.05;
		}

		// update polygon transformation to apply rotation
		polygon.transform(x_center, y_center, rotation, scale);

		Peote.update(elapsed_seconds);
	}

	var isReady:Bool;
	var triangle:IsoscelesModel;
	var x_center:Float;
	var y_center:Float;
	var polygon:Polygon;
	var rotation:Float = 0;
	var scale:Float = 20;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;
}