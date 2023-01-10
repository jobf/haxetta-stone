
import Graphics;
import Engine;
import lime.graphics.RenderContext;
import haxe.CallStack;
import lime.app.Application;
import lime.ui.Window;

class Main extends Application {
	// override function onWindowCreate():Void {
	// 	window 
	// }

	override function onPreloadComplete() {
		super.onPreloadComplete();
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
		var slate = 0x151517ff;
		implementation_graphics = new Graphics(window, bounds_viewport);
		implementation_input = new Input(window);
		implementation_graphics.set_color(slate);
		// var init_scene:Game->Scene = game -> new DesignerScene(game, bounds_scene, black);
		var init_scene:Game->Scene = game -> new LunarScene(game, bounds_scene, black);
		#if model_test
		init_scene = game -> new ModelTestScene(game, bounds_scene, black);
		#end
		#if model_design
		init_scene = game -> new DesignerScene(game, bounds_scene, black);
		#end

		game = new Game(init_scene, implementation_graphics, implementation_input);
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
				
		if (!isReady) {
			return;
		}

		game.draw();
	}

	var isReady:Bool;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;
	var game:Game;

	var implementation_graphics:Graphics;
	var implementation_input:Input;
}