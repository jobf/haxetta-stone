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

@:structInit
class InputAbstract {
	public var on_pressed:(button:Button) -> Void = b -> trace(b);
	public var on_released:(button:Button) -> Void = b -> trace(b);
	public var get_mouse_position:Void -> Vector = ()-> return { x: 0, y: 0 };

	public function button_press(button:Button) {
		on_pressed(button);
	}

	public function button_release(button:Button) {
		on_released(button);
	}
}
