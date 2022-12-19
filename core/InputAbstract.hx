enum Button {
	NONE;
	KEY_LEFT;
	KEY_RIGHT;
	KEY_UP;
	KEY_DOWN;
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

	public function button_press(button:Button) {
		on_pressed(button);
	}

	public function button_release(button:Button) {
		on_released(button);
	}
}
