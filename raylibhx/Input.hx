import InputAbstract.Button;
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

		press_if_pressed(Keys.A, on_pressed, KEY_A);
		press_if_pressed(Keys.B, on_pressed, KEY_B);
		press_if_pressed(Keys.C, on_pressed, KEY_C);
		press_if_pressed(Keys.D, on_pressed, KEY_D);
		press_if_pressed(Keys.E, on_pressed, KEY_E);
		press_if_pressed(Keys.F, on_pressed, KEY_F);
		press_if_pressed(Keys.G, on_pressed, KEY_G);
		press_if_pressed(Keys.H, on_pressed, KEY_H);
		press_if_pressed(Keys.I, on_pressed, KEY_I);
		press_if_pressed(Keys.J, on_pressed, KEY_J);
		press_if_pressed(Keys.K, on_pressed, KEY_K);
		press_if_pressed(Keys.L, on_pressed, KEY_L);
		press_if_pressed(Keys.M, on_pressed, KEY_M);
		press_if_pressed(Keys.N, on_pressed, KEY_N);
		press_if_pressed(Keys.O, on_pressed, KEY_O);
		press_if_pressed(Keys.P, on_pressed, KEY_P);
		press_if_pressed(Keys.Q, on_pressed, KEY_Q);
		press_if_pressed(Keys.R, on_pressed, KEY_R);
		press_if_pressed(Keys.S, on_pressed, KEY_S);
		press_if_pressed(Keys.T, on_pressed, KEY_T);
		press_if_pressed(Keys.U, on_pressed, KEY_U);
		press_if_pressed(Keys.V, on_pressed, KEY_V);
		press_if_pressed(Keys.W, on_pressed, KEY_W);
		press_if_pressed(Keys.X, on_pressed, KEY_X);
		press_if_pressed(Keys.Y, on_pressed, KEY_Y);
		press_if_pressed(Keys.Z, on_pressed, KEY_Z);

		release_if_released(Keys.A, on_released, KEY_A);
		release_if_released(Keys.B, on_released, KEY_B);
		release_if_released(Keys.C, on_released, KEY_C);
		release_if_released(Keys.D, on_released, KEY_D);
		release_if_released(Keys.E, on_released, KEY_E);
		release_if_released(Keys.F, on_released, KEY_F);
		release_if_released(Keys.G, on_released, KEY_G);
		release_if_released(Keys.H, on_released, KEY_H);
		release_if_released(Keys.I, on_released, KEY_I);
		release_if_released(Keys.J, on_released, KEY_J);
		release_if_released(Keys.K, on_released, KEY_K);
		release_if_released(Keys.L, on_released, KEY_L);
		release_if_released(Keys.M, on_released, KEY_M);
		release_if_released(Keys.N, on_released, KEY_N);
		release_if_released(Keys.O, on_released, KEY_O);
		release_if_released(Keys.P, on_released, KEY_P);
		release_if_released(Keys.Q, on_released, KEY_Q);
		release_if_released(Keys.R, on_released, KEY_R);
		release_if_released(Keys.S, on_released, KEY_S);
		release_if_released(Keys.T, on_released, KEY_T);
		release_if_released(Keys.U, on_released, KEY_U);
		release_if_released(Keys.V, on_released, KEY_V);
		release_if_released(Keys.W, on_released, KEY_W);
		release_if_released(Keys.X, on_released, KEY_X);
		release_if_released(Keys.Y, on_released, KEY_Y);
		release_if_released(Keys.Z, on_released, KEY_Z);
	}


	inline function press_if_pressed(button_rl:Keys, on_press:Button->Void, button:Button){
		if(Rl.isKeyPressed(button_rl)){
			on_press(button);
		}
	}

	inline function release_if_released(button_rl:Keys, on_release:Button->Void, button:Button){
		if(Rl.isKeyReleased(button_rl)){
			on_release(button);
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
