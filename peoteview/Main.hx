
import peote.view.Display;
import peote.view.PeoteView;
import graphics.implementation.Graphics;
import Engine;
import lime.graphics.RenderContext;
import haxe.CallStack;
import lime.app.Application;
import lime.ui.Window;
import GraphicsAbstract;
import Models;
import Disk;

class Main extends Application {
	// override function onWindowCreate():Void {
	// 	window 
	// }
	var peoteview:PeoteView;
	var display_main:Display;
	var display_hud:Display;

	var isReady:Bool;
	var time:Float = 0;
	var elapsed_seconds:Float = 0;
	var game:Game;

	var implementation_graphics:Graphics;
	var implementation_input:Input;


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
		
		var black = 0x000000ff;
		var slate = 0x151517ff;

		// this.window = window;
		peoteview = new PeoteView(window);
		
		display_main = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display_main);

		display_hud = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display_hud);

		implementation_graphics = new Graphics(display_main, bounds_viewport);
		implementation_input = new Input(window);
		implementation_graphics.set_color(slate);
		// var init_scene:Game->Scene = game -> new DesignerScene(game, bounds_scene, black);

		var hud_graphics = new Graphics(display_hud, bounds_viewport);
		var init_scene:Game->Scene = game -> new LunarScene(hud_graphics, bounds_viewport, game, black);
		
		#if model_test
		init_scene = game -> new ModelTestScene(game, bounds_viewport, black);
		#end
		#if model_design
		#end
		init_scene = game -> new DesignerScene(game, bounds_viewport, slate);

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

}