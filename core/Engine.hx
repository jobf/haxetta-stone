import InputAbstract;
import GraphicsAbstract;

class Game {
	var current_scene:Scene;
	public var graphics(default, null):GraphicsAbstract;
	public var input(default, null):InputAbstract;

	public function new(scene_constructor:Game->Scene, graphics:GraphicsAbstract, input:InputAbstract) {
		this.graphics = graphics;
		this.input = input;
		current_scene = scene_constructor(this);
		current_scene.init();
	}

	public function update(elapsed_seconds:Float) {
		current_scene.update(elapsed_seconds);
	}

	public function draw() {
		current_scene.draw();
	}
}

abstract class Scene {
	var game:Game;
	var bounds:RectangleGeometry;

	public var color(default, null):Int;

	public function new(game:Game, bounds:RectangleGeometry, color:Int) {
		this.game = game;
		this.bounds = bounds;
		this.color = color;
	}

	/**
		Handle scene initiliasation here, e.g. set up level, player, etc.
	**/
	abstract public function init():Void;

	/**
		Handle game logic here, e,g, calculating movement for player, change object states, etc.
		@param elapsed_seconds is the amount of seconds that have passed since the last frame
	**/
	abstract public function update(elapsed_seconds:Float):Void;

	/**
		Make draw calls here
	**/
	abstract public function draw():Void;
}

@:structInit
class RectangleGeometry {
	public var x:Int = 0;
	public var y:Int = 0;
	public var width:Int;
	public var height:Int;
}