import Vector;

enum Button {
	NONE;
	MOUSE_LEFT;
	MOUSE_MIDDLE;
	MOUSE_RIGHT;
	KEY_LEFT;
	KEY_RIGHT;
	KEY_UP;
	KEY_DOWN;
	KEY_A;
	KEY_B;
	KEY_C;
	KEY_D;
	KEY_E;
	KEY_F;
	KEY_G;
	KEY_H;
	KEY_I;
	KEY_J;
	KEY_K;
	KEY_L;
	KEY_M;
	KEY_N;
	KEY_O;
	KEY_P;
	KEY_Q;
	KEY_R;
	KEY_S;
	KEY_T;
	KEY_U;
	KEY_V;
	KEY_W;
	KEY_X;
	KEY_Y;
	KEY_Z;
}

enum ButtonState {
	NONE;
	PRESSED;
	RELEASED;
}

abstract class InputAbstract {
	public function new() {
		mouse_position = {
			x: 0,
			y: 0
		}
	}

	public var mouse_position(default, null):Vector;

	abstract public function raise_mouse_button_events():Void;

	abstract public function raise_keyboard_button_events():Void;

	abstract public function update_mouse_position():Void;

	abstract public function mouse_cursor_hide():Void;
	
	abstract public function mouse_cursor_show():Void;

	public var on_pressed:(button:Button) -> Void = b -> trace(b);
	public var on_released:(button:Button) -> Void = b -> trace(b);
}
