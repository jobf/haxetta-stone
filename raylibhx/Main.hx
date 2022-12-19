import haxe.io.Input;
import sys.ssl.Key;
import Rl;
import InputAbstract;
import GraphicsAbstract;
import Graphics;
import Engine;

class Main {
	static var game:Game;

	static function main() {
		var bounds_viewport:RectangleGeometry = {
			width: 640,
			height: 480
		}

		Rl.initWindow(bounds_viewport.width, bounds_viewport.height, "particles");
		Rl.setWindowState(Rl.ConfigFlags.VSYNC_HINT);

		
		var bounds_scene:RectangleGeometry = {
			y: 0,
			x: 0,
			width: bounds_viewport.width,
			height: bounds_viewport.height
		}

		var black = 0x000000ff;
		var init_scene = game -> new SpaceScene(game, bounds_scene, black);

		var implementation_graphics:GraphicsAbstract = {
			viewport_bounds: bounds_viewport,
			make_polygon: (model, color) -> Raylib.make_polygon(model, color),
			make_particle: (x, y, size, color, lifetime_seconds) -> Raylib.make_particle(x, y, color, size, lifetime_seconds)
		}

		game = new Game(init_scene, implementation_graphics);

		while (!Rl.windowShouldClose()) {
			Rl.clearBackground(Colors.BLACK); // todo
			handle_input();
			game.update(Rl.getFrameTime());
			Rl.beginDrawing();
			game.draw();
			Rl.endDrawing();
		}

		Rl.closeWindow();
	}

	static function handle_input() {
		if(Rl.isKeyPressed(Keys.LEFT)){
			game.input.button_press(KEY_LEFT);
		}
		if(Rl.isKeyPressed(Keys.RIGHT)){
			game.input.button_press(KEY_RIGHT);
		}
		if(Rl.isKeyPressed(Keys.UP)){
			game.input.button_press(KEY_UP);
		}
		if(Rl.isKeyPressed(Keys.DOWN)){
			game.input.button_press(KEY_DOWN);
		}
		if(Rl.isKeyReleased(Keys.LEFT)){
			game.input.button_release(KEY_LEFT);
		}
		if(Rl.isKeyReleased(Keys.RIGHT)){
			game.input.button_release(KEY_RIGHT);
		}
		if(Rl.isKeyReleased(Keys.UP)){
			game.input.button_release(KEY_UP);
		}
		if(Rl.isKeyReleased(Keys.DOWN)){
			game.input.button_release(KEY_DOWN);
		}
	}
}
