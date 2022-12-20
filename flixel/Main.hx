import openfl.display.Sprite;
import flixel.FlxGame;
import flixel.FlxG;
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
		var init_scene = game -> new SpaceScene(game, bounds_scene, black);

		var implementation_graphics = new Graphics(this, bounds_viewport);

		game = new Game(init_scene, implementation_graphics);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		update_button_states();
		game.update(elapsed);
	}

	override function draw() {
		super.draw();
		game.draw();
	}

	function update_button_states() {
		if(FlxG.keys.justPressed.LEFT){
			game.input.button_press(KEY_LEFT);
		}
		if(FlxG.keys.justReleased.LEFT){
			game.input.button_release(KEY_LEFT);
		}

		if(FlxG.keys.justPressed.RIGHT){
			game.input.button_press(KEY_RIGHT);
		}
		if(FlxG.keys.justReleased.RIGHT){
			game.input.button_release(KEY_RIGHT);
		}

		if(FlxG.keys.justPressed.UP){
			game.input.button_press(KEY_UP);
		}
		if(FlxG.keys.justReleased.UP){
			game.input.button_release(KEY_UP);
		}

		if(FlxG.keys.justPressed.DOWN){
			game.input.button_press(KEY_DOWN);
		}
		if(FlxG.keys.justReleased.DOWN){
			game.input.button_release(KEY_DOWN);
		}
	}
}

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
