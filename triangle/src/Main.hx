package;

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
	var rotation:Float = 0;
	var time:Float = 0;
	override function update(deltaTime:Int):Void {
		if(!isReady){
			return;
		}
		var elapsed_seconds = deltaTime / 1000;
		time += elapsed_seconds;

		Peote.clear();
		
		// occasionally increase the rotation
		if (Std.int(time * 60) % 3 == 0) {
			rotation += 0.05;
		}
		
		DrawTrianglePoints(triangle.points, x_center, y_center, rotation, 20, Color.GREEN);
		
		Peote.update(elapsed_seconds);
	}

	var isReady:Bool;
	var triangle:IsoscelesModel;
	var x_center:Float;
	var y_center:Float;
}

function DrawTrianglePoints(points:Array<Point>, x_center:Float, y_center:Float, rotation:Float, scale:Float, color:Color){
	var rotation_sin = Math.sin(rotation);
	var rotation_cos = Math.cos(rotation);

	// first apply rotation to the model points
	var points_transformed:Array<Point> = [for(i in 0...points.length) {
		x: points[i].x * rotation_cos - points[i].y * rotation_sin,
		y: points[i].x * rotation_sin + points[i].y * rotation_cos
	}];

	// now scale the transformed points (change size)
	for(i in 0...points.length){
		points_transformed[i].x = points_transformed[i].x * scale;
		points_transformed[i].y = points_transformed[i].y * scale;
	}

	// now translate the transformed point positions
	for(i in 0...points.length){
		points_transformed[i].x = points_transformed[i].x + x_center;
		points_transformed[i].y = points_transformed[i].y + y_center;
	}

	Peote.draw_polygon(points_transformed, color);
}
