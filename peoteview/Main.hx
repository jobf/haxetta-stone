
import lime.ui.MouseButton;
import InputAbstract;
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

		var implementation_graphics = new Graphics(window, bounds_viewport);

		game = new Game(init_scene, implementation_graphics);
		game.input.get_mouse_position = () -> mouse_position;
		mouse_position = {
			y: 0,
			x: 0
		}
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

	override function onMouseDown(x:Float, y:Float, button:MouseButton) {
		super.onMouseDown(x, y, button);
		switch button {
			case LEFT: game.input.button_press(MOUSE_LEFT);
			case MIDDLE: game.input.button_press(MOUSE_MIDDLE);
			case RIGHT: game.input.button_press(MOUSE_RIGHT);
		}
	}

	override function onMouseUp(x:Float, y:Float, button:MouseButton) {
		super.onMouseUp(x, y, button);
		switch button {
			case LEFT: game.input.button_release(MOUSE_LEFT);
			case MIDDLE: game.input.button_release(MOUSE_MIDDLE);
			case RIGHT: game.input.button_release(MOUSE_RIGHT);
		}
	}

	override function onMouseMove(x:Float, y:Float) {
		super.onMouseMove(x, y);
		mouse_position.x = x;
		mouse_position.y = y;
	}


	var isReady:Bool;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;
	var game:Game;

	var mouse_position(default, null):Vector;
}