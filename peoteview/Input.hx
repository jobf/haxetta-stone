import lime.ui.MouseButton;
import InputAbstract.Button;
import lime.ui.KeyCode;
import lime.ui.Window;

class Input extends InputAbstract {
	public function new(window:Window) {
		window.onKeyDown.add((code, modifier) -> keyboard_down.push(to_keyboard_button(code)));

		window.onKeyUp.add((code, modifier) -> keyboard_up.push(to_keyboard_button(code)));

		window.onMouseDown.add((x, y, button) -> mouse_down.push(to_mouse_button(button)));

		window.onMouseUp.add((x, y, button) -> mouse_up.push(to_mouse_button(button)));

		window.onMouseMove.add((x, y) -> {
			mouse_x = x;
			mouse_y = y;
		});

		super();
	}

	public function raise_mouse_button_events() {
		for (button in mouse_down) {
			on_pressed(button);
		}
		mouse_down = [];

		for (button in mouse_up) {
			on_released(button);
		}
		mouse_up = [];

	}

	public function raise_keyboard_button_events() {
		for (button in keyboard_down) {
			on_pressed(button);
		}
		keyboard_down = [];

		for (button in keyboard_up) {
			on_released(button);
		}
		keyboard_up = [];
	}

	public function update_mouse_position() {
		mouse_position.x = mouse_x;
		mouse_position.y = mouse_y;
	}

	var keyboard_down:Array<Button> = [];
	var keyboard_up:Array<Button> = [];

	var mouse_x:Float;
	var mouse_y:Float;
	var mouse_down:Array<Button> = [];
	var mouse_up:Array<Button> = [];
}

function to_mouse_button(button:MouseButton):Button {
	return switch button {
		case LEFT: MOUSE_LEFT;
		case MIDDLE: MOUSE_MIDDLE;
		case RIGHT: MOUSE_RIGHT;
	}
}

function to_keyboard_button(code:KeyCode):Button {
	return switch code {
		// case UNKNOWN:
		// case BACKSPACE:
		// case TAB:
		// case RETURN:
		// case ESCAPE:
		// case SPACE:
		// case EXCLAMATION:
		// case QUOTE:
		// case HASH:
		// case DOLLAR:
		// case PERCENT:
		// case AMPERSAND:
		// case SINGLE_QUOTE:
		// case LEFT_PARENTHESIS:
		// case RIGHT_PARENTHESIS:
		// case ASTERISK:
		// case PLUS:
		// case COMMA:
		// case MINUS:
		// case PERIOD:
		// case SLASH:
		// case NUMBER_0:
		// case NUMBER_1:
		// case NUMBER_2:
		// case NUMBER_3:
		// case NUMBER_4:
		// case NUMBER_5:
		// case NUMBER_6:
		// case NUMBER_7:
		// case NUMBER_8:
		// case NUMBER_9:
		// case COLON:
		// case SEMICOLON:
		// case LESS_THAN:
		// case EQUALS:
		// case GREATER_THAN:
		// case QUESTION:
		// case AT:
		// case LEFT_BRACKET:
		// case BACKSLASH:
		// case RIGHT_BRACKET:
		// case CARET:
		// case UNDERSCORE:
		// case GRAVE:
		// case A:
		// case B:
		// case C:
		// case D:
		// case E:
		// case F:
		// case G:
		// case H:
		// case I:
		// case J:
		// case K:
		// case L:
		// case M:
		// case N:
		// case O:
		// case P:
		// case Q:
		// case R:
		// case S:
		// case T:
		// case U:
		// case V:
		// case W:
		// case X:
		// case Y:
		// case Z:
		// case DELETE:
		// case CAPS_LOCK:
		// case F1:
		// case F2:
		// case F3:
		// case F4:
		// case F5:
		// case F6:
		// case F7:
		// case F8:
		// case F9:
		// case F10:
		// case F11:
		// case F12:
		// case PRINT_SCREEN:
		// case SCROLL_LOCK:
		// case PAUSE:
		// case INSERT:
		// case HOME:
		// case PAGE_UP:
		// case END:
		// case PAGE_DOWN:
		case RIGHT: KEY_RIGHT;
		case LEFT: KEY_LEFT;
		case DOWN: KEY_DOWN;
		case UP: KEY_UP;
		// case NUM_LOCK:
		// case NUMPAD_DIVIDE:
		// case NUMPAD_MULTIPLY:
		// case NUMPAD_MINUS:
		// case NUMPAD_PLUS:
		// case NUMPAD_ENTER:
		// case NUMPAD_1:
		// case NUMPAD_2:
		// case NUMPAD_3:
		// case NUMPAD_4:
		// case NUMPAD_5:
		// case NUMPAD_6:
		// case NUMPAD_7:
		// case NUMPAD_8:
		// case NUMPAD_9:
		// case NUMPAD_0:
		// case NUMPAD_PERIOD:
		// case APPLICATION:
		// case POWER:
		// case NUMPAD_EQUALS:
		// case F13:
		// case F14:
		// case F15:
		// case F16:
		// case F17:
		// case F18:
		// case F19:
		// case F20:
		// case F21:
		// case F22:
		// case F23:
		// case F24:
		// case EXECUTE:
		// case HELP:
		// case MENU:
		// case SELECT:
		// case STOP:
		// case AGAIN:
		// case UNDO:
		// case CUT:
		// case COPY:
		// case PASTE:
		// case FIND:
		// case MUTE:
		// case VOLUME_UP:
		// case VOLUME_DOWN:
		// case NUMPAD_COMMA:
		// case ALT_ERASE:
		// case SYSTEM_REQUEST:
		// case CANCEL:
		// case CLEAR:
		// case PRIOR:
		// case RETURN2:
		// case SEPARATOR:
		// case OUT:
		// case OPER:
		// case CLEAR_AGAIN:
		// case CRSEL:
		// case EXSEL:
		// case NUMPAD_00:
		// case NUMPAD_000:
		// case THOUSAND_SEPARATOR:
		// case DECIMAL_SEPARATOR:
		// case CURRENCY_UNIT:
		// case CURRENCY_SUBUNIT:
		// case NUMPAD_LEFT_PARENTHESIS:
		// case NUMPAD_RIGHT_PARENTHESIS:
		// case NUMPAD_LEFT_BRACE:
		// case NUMPAD_RIGHT_BRACE:
		// case NUMPAD_TAB:
		// case NUMPAD_BACKSPACE:
		// case NUMPAD_A:
		// case NUMPAD_B:
		// case NUMPAD_C:
		// case NUMPAD_D:
		// case NUMPAD_E:
		// case NUMPAD_F:
		// case NUMPAD_XOR:
		// case NUMPAD_POWER:
		// case NUMPAD_PERCENT:
		// case NUMPAD_LESS_THAN:
		// case NUMPAD_GREATER_THAN:
		// case NUMPAD_AMPERSAND:
		// case NUMPAD_DOUBLE_AMPERSAND:
		// case NUMPAD_VERTICAL_BAR:
		// case NUMPAD_DOUBLE_VERTICAL_BAR:
		// case NUMPAD_COLON:
		// case NUMPAD_HASH:
		// case NUMPAD_SPACE:
		// case NUMPAD_AT:
		// case NUMPAD_EXCLAMATION:
		// case NUMPAD_MEM_STORE:
		// case NUMPAD_MEM_RECALL:
		// case NUMPAD_MEM_CLEAR:
		// case NUMPAD_MEM_ADD:
		// case NUMPAD_MEM_SUBTRACT:
		// case NUMPAD_MEM_MULTIPLY:
		// case NUMPAD_MEM_DIVIDE:
		// case NUMPAD_PLUS_MINUS:
		// case NUMPAD_CLEAR:
		// case NUMPAD_CLEAR_ENTRY:
		// case NUMPAD_BINARY:
		// case NUMPAD_OCTAL:
		// case NUMPAD_DECIMAL:
		// case NUMPAD_HEXADECIMAL:
		// case LEFT_CTRL:
		// case LEFT_SHIFT:
		// case LEFT_ALT:
		// case LEFT_META:
		// case RIGHT_CTRL:
		// case RIGHT_SHIFT:
		// case RIGHT_ALT:
		// case RIGHT_META:
		// case MODE:
		// case AUDIO_NEXT:
		// case AUDIO_PREVIOUS:
		// case AUDIO_STOP:
		// case AUDIO_PLAY:
		// case AUDIO_MUTE:
		// case MEDIA_SELECT:
		// case WWW:
		// case MAIL:
		// case CALCULATOR:
		// case COMPUTER:
		// case APP_CONTROL_SEARCH:
		// case APP_CONTROL_HOME:
		// case APP_CONTROL_BACK:
		// case APP_CONTROL_FORWARD:
		// case APP_CONTROL_STOP:
		// case APP_CONTROL_REFRESH:
		// case APP_CONTROL_BOOKMARKS:
		// case BRIGHTNESS_DOWN:
		// case BRIGHTNESS_UP:
		// case DISPLAY_SWITCH:
		// case BACKLIGHT_TOGGLE:
		// case BACKLIGHT_DOWN:
		// case BACKLIGHT_UP:
		// case EJECT:
		// case SLEEP:
		case _: NONE;
	}
}