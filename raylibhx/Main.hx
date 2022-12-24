import Rl;
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
		// var init_scene = game -> new DesignerScene(game, bounds_scene, black);
		
		var implementation_graphics = new Graphics(bounds_viewport);
		var implementation_input = new Input();

		game = new Game(init_scene, implementation_graphics, implementation_input);

		while (!Rl.windowShouldClose()) {
			Rl.clearBackground(Colors.BLACK); // todo
			game.update(Rl.getFrameTime());
			Rl.beginDrawing();
			game.draw();
			Rl.endDrawing();
		}

		Rl.closeWindow();
	}
}
