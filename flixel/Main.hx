import openfl.display.Sprite;
import flixel.FlxGame;
import flixel.FlxState;
import Graphics;
import Engine;

class PlayState extends FlxState {
	var game:Game;

	override public function create() {
		super.create();
		var bounds_viewport:RectangleGeometry = {
			width: 640,
			height: 480
		}

		var bounds_scene:RectangleGeometry = {
			y: 0,
			x: 0,
			width: bounds_viewport.width,
			height: bounds_viewport.height
		}

		var black = 0x000000ff;

		// var init_scene = game -> new SpaceScene(game, bounds_scene, black);
		var init_scene = game -> new DesignerScene(game, bounds_scene, black);

		var implementation_graphics = new Graphics(this, bounds_viewport);
		var implementation_input = new Input();

		game = new Game(init_scene, implementation_graphics, implementation_input);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		game.update(elapsed);
	}

	override function draw() {
		super.draw();
		game.draw();
	}
}

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
