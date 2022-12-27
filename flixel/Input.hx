import flixel.math.FlxPoint;
import flixel.FlxG;

class Input extends InputAbstract {
	var mouse_flx_point:FlxPoint;

	function raise_mouse_button_events() {
		if (FlxG.mouse.justPressed) {
			on_pressed(MOUSE_LEFT);
		}
		if (FlxG.mouse.justReleased) {
			on_released(MOUSE_LEFT);
		}
		if (FlxG.mouse.justPressed) {
			on_pressed(MOUSE_MIDDLE);
		}
		if (FlxG.mouse.justReleased) {
			on_released(MOUSE_MIDDLE);
		}

		if (FlxG.mouse.justPressed) {
			on_pressed(MOUSE_RIGHT);
		}
		if (FlxG.mouse.justReleased) {
			on_released(MOUSE_RIGHT);
		}
	}

	function raise_keyboard_button_events() {
		if (FlxG.keys.justPressed.LEFT) {
			on_pressed(KEY_LEFT);
		}
		if (FlxG.keys.justReleased.LEFT) {
			on_released(KEY_LEFT);
		}

		if (FlxG.keys.justPressed.RIGHT) {
			on_pressed(KEY_RIGHT);
		}
		if (FlxG.keys.justReleased.RIGHT) {
			on_released(KEY_RIGHT);
		}

		if (FlxG.keys.justPressed.UP) {
			on_pressed(KEY_UP);
		}
		if (FlxG.keys.justReleased.UP) {
			on_released(KEY_UP);
		}

		if (FlxG.keys.justPressed.DOWN) {
			on_pressed(KEY_DOWN);
		}
		if (FlxG.keys.justReleased.DOWN) {
			on_released(KEY_DOWN);
		}
	}

	function update_mouse_position() {
		mouse_flx_point = FlxG.mouse.getPosition(mouse_flx_point);
		mouse_position.x = mouse_flx_point.x;
		mouse_position.y = mouse_flx_point.y;
	}

	public function mouse_cursor_hide() {
		FlxG.mouse.visible = false;
	}

	public function mouse_cursor_show() {
		FlxG.mouse.visible = true;
	}
}
