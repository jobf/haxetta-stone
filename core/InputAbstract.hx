enum Button {
	NONE;
	KEY_LEFT;
	KEY_RIGHT;
	KEY_UP;
	KEY_DOWN;
}

enum ButtonState{
	NONE;
	PRESSED;
	RELEASED;
}

@:structInit
class InputAbstract {
	public var get_button_state:Button->ButtonState;
}
