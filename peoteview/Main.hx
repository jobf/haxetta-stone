
import InputAbstract;
import GraphicsAbstract;
import Graphics;
import Engine;
import lime.graphics.RenderContext;
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
					init(window)
				catch (_)
					trace(CallStack.toString(CallStack.exceptionStack()), _);
			default:
				throw("Sorry, only works with OpenGL.");
		}
	}

	public function init(window:Window) {
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

		var implementation_graphics:GraphicsAbstract = {
			viewport_bounds: bounds_viewport,
			make_polygon: (model, color) -> Peote.make_polygon(model, cast color),
			make_particle: (x, y, size, color, lifetime_seconds) -> Peote.make_particle(x, y, cast color, size, lifetime_seconds)
		}

		game = new Game(init_scene, implementation_graphics);

		isReady = true;
	}

	override function update(deltaTime:Int):Void {
		super.update(deltaTime);
		
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

	override function onKeyDown(keyCode:KeyCode, modifier:KeyModifier) {
		super.onKeyDown(keyCode, modifier);
		switch keyCode {
			case DOWN: game.input.button_press(KEY_DOWN);
			case UP: game.input.button_press(KEY_UP);
			case LEFT: game.input.button_press(KEY_LEFT);
			case RIGHT: game.input.button_press(KEY_RIGHT);
			case _: return;
		}
	}

	override function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
		super.onKeyUp(keyCode, modifier);
		switch keyCode {
			case DOWN: game.input.button_release(KEY_DOWN);
			case UP: game.input.button_release(KEY_UP);
			case LEFT: game.input.button_release(KEY_LEFT);
			case RIGHT: game.input.button_release(KEY_RIGHT);
			case _: return;
		}
	}


	var isReady:Bool;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;
	var game:Game;
}