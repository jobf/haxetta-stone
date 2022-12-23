import Vector;

enum Button {
	NONE;
	KEY_LEFT;
	KEY_RIGHT;
	KEY_UP;
	KEY_DOWN;
	MOUSE_LEFT;
	MOUSE_MIDDLE;
	MOUSE_RIGHT;
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

	public var on_pressed:(button:Button) -> Void = b -> trace(b);
	public var on_released:(button:Button) -> Void = b -> trace(b);
}
