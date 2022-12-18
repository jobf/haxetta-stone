import Rl;
import InputAbstract;
import GraphicsAbstract;
import Graphics;
import Engine;

class Main {
	static var game:Game;

	static var button_states:Map<Button, ButtonState> = [
		NONE => NONE,
		KEY_LEFT => NONE,
		KEY_RIGHT => NONE,
		KEY_UP => NONE,
		KEY_DOWN => NONE,
	];

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

		var implementation_input:InputAbstract = {
			get_button_state: button -> button_states[button]
		};

		game = new Game(init_scene, implementation_graphics, implementation_input);

		while (!Rl.windowShouldClose()) {
			Rl.clearBackground(Colors.BLACK); // todo
			update_button_states();
			game.update(Rl.getFrameTime());
			Rl.beginDrawing();
			game.draw();
			Rl.endDrawing();
		}

		Rl.closeWindow();
	}

	static inline function get_key_state(key:Keys):ButtonState{
		return Rl.isKeyPressed(key) ? PRESSED : Rl.isKeyReleased(key) ? RELEASED : NONE;
	}

	static function update_button_states() {
		button_states[KEY_LEFT] = get_key_state(Keys.LEFT);
		button_states[KEY_RIGHT] = get_key_state(Keys.RIGHT);
		button_states[KEY_UP] = get_key_state(Keys.UP);
		button_states[KEY_DOWN] = get_key_state(Keys.DOWN);
	}
}
