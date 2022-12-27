import Rl;

class Input extends InputAbstract {
	var rl_mouse_position:Vector2;

	public function raise_mouse_button_events() {
		if (Rl.isMouseButtonPressed(MouseButton.LEFT)) {
			on_pressed(MOUSE_LEFT);
		}
		if (Rl.isMouseButtonReleased(MouseButton.LEFT)) {
			on_released(MOUSE_LEFT);
		}

		if (Rl.isMouseButtonPressed(MouseButton.MIDDLE)) {
			on_pressed(MOUSE_MIDDLE);
		}
		if (Rl.isMouseButtonReleased(MouseButton.MIDDLE)) {
			on_released(MOUSE_MIDDLE);
		}

		if (Rl.isMouseButtonPressed(MouseButton.RIGHT)) {
			on_pressed(MOUSE_RIGHT);
		}
		if (Rl.isMouseButtonReleased(MouseButton.RIGHT)) {
			on_released(MOUSE_RIGHT);
		}
	}

	public function raise_keyboard_button_events() {
		if (Rl.isKeyPressed(Keys.LEFT)) {
			on_pressed(KEY_LEFT);
		}
		if (Rl.isKeyReleased(Keys.LEFT)) {
			on_released(KEY_LEFT);
		}

		if (Rl.isKeyPressed(Keys.RIGHT)) {
			on_pressed(KEY_RIGHT);
		}
		if (Rl.isKeyReleased(Keys.RIGHT)) {
			on_released(KEY_RIGHT);
		}

		if (Rl.isKeyPressed(Keys.UP)) {
			on_pressed(KEY_UP);
		}
		if (Rl.isKeyReleased(Keys.UP)) {
			on_released(KEY_UP);
		}

		if (Rl.isKeyPressed(Keys.DOWN)) {
			on_pressed(KEY_DOWN);
		}
		if (Rl.isKeyReleased(Keys.DOWN)) {
			on_released(KEY_DOWN);
		}
	}

	public function update_mouse_position() {
		rl_mouse_position = Rl.getMousePosition();
		mouse_position.x = rl_mouse_position.x;
		mouse_position.y = rl_mouse_position.y;
	}

	public function mouse_cursor_hide() {
		Rl.hideCursor();
	}

	public function mouse_cursor_show() {
		Rl.showCursor();
	}
}
