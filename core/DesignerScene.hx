import Graphics.PeoteLine;
import Editor;
import Models;
import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;
import Disk;
import dials.SettingsController;
import dials.Disk;

using Vector;

class DesignerScene extends Scene {
	var x_center:Int;
	var y_center:Int;
	var mouse_position:Vector;
	var designer:Designer;
	var x_axis_line:PeoteLine;
	var y_axis_line:PeoteLine;
	var settings:SettingsController;

	public function init() {
		// game.input.mouse_cursor_hide();/
		
		mouse_position = game.input.mouse_position;
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		
		var size_segment = 64;//Std.int(game.graphics.viewport_bounds.width / 7);
		for (x in 0...Std.int(bounds.width / size_segment)) {
			var x_ = Std.int(x * size_segment);
			game.graphics.make_line(x_, 0, x_, bounds.height, 0xD1D76280);
		}
		for (y in 0...Std.int(bounds.height / size_segment)) {
			var y_ = Std.int(y * size_segment);
			game.graphics.make_line(0, y_, bounds.width, y_, 0xD1D76280);
		}

		x_axis_line = cast game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFF85AB80);
		y_axis_line = cast game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFF85AB80);
		// y_axis_line = cast game.graphics.make_line(x_center, 0, x_center, bounds.height, 0xFF85AB80);

		designer = new Designer(size_segment, game.graphics, bounds);

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> handle_mouse_press_left(),
				on_released: () -> handle_mouse_release_left()
			},
			MOUSE_RIGHT => {
				on_pressed: () -> handle_mouse_press_right(),
			},
			MOUSE_MIDDLE => {
				on_pressed: () -> designer.save_state(false),
			},
			KEY_LEFT => {
				on_pressed: () -> designer.set_active_figure(-1)
			},
			KEY_RIGHT => {
				on_pressed: () -> designer.set_active_figure(1)
			},
			KEY_N => {
				on_pressed: () -> designer.add_new_figure()
			},
			KEY_S => {
				on_pressed: ()->designer.save_state(false),
			}
		];

		game.input.on_pressed = button -> {
			if (actions.exists(button)) {
				actions[button].on_pressed();
			}
		}

		game.input.on_released = button -> {
			if (actions.exists(button)) {
				actions[button].on_released();
			}
		}
		var page:Page = {
			pads: [],
			name: "one",
		}

		settings = new SettingsController(new DiskSys());
		settings.page_add(page);
		

		var g:Graphics = cast game.graphics;
		@:privateAccess
		var display = g.display;
		display.zoom = 1.16;
		display.xOffset = 0;
		display.yOffset = 0;
		settings.pad_add({
			name: "camera",
			index_palette: 1,
			// index: index,
			encoders: [
				VOLUME => {
					value: display.xOffset,
					on_change: f -> display.xOffset = f,
					name: "x offset",
					minimum: -100000,
					maximum: 100000,
					increment: 10
				},
				PAN => {
					value: display.yOffset,
					on_change: f -> display.yOffset = f,
					name: "y offset",
					minimum: -100000,
					maximum: 100000,
					increment: 10
				},
				// FILTER => {
				// 	value: entity.scale,
				// 	on_change: f -> entity.scale = Std.int(f),
				// 	name: "scale",
				// 	// increment: 0.1,
				// 	minimum: 0.001
				// },
				RESONANCE => {
					value: display.zoom,
					on_change: f -> display.zoom = f,
					name: "zoom",
					minimum: 0.1,
					increment: 0.01
				}
			]
		}, page.index);
		x_axis_line.rotation_override = 0;
		settings.pad_add({
			name: "x_axis_line",
			index_palette: 0,
			// index: index,
			encoders: [
				VOLUME => {
					value: x_axis_line.thick = 200,
					on_change: f -> x_axis_line.thick = Std.int(f),
					name: "thicc ",
					increment: 1,
					minimum: 1,
					// maximum: 10000
				},
				PAN => {
					value: x_axis_line.element.px,// = 50,
					on_change: f -> x_axis_line.element.px = Std.int(f),
					name: "x pivot",
					increment: 1,
					minimum: -10000,
					maximum: 10000
				},
				FILTER => {
					value: x_axis_line.element.px,// = 50,
					on_change: f -> x_axis_line.element.px = Std.int(f),
					name: "y pivot",
					increment: 1,
					minimum: -10000,
					maximum: 10000
				},
				RESONANCE => {
					value: x_axis_line.rotation_override = -45,
					on_change: f -> x_axis_line.rotation_override = f,
					name: "rotation",
					increment: 0.1,
					minimum: -360
				}
			]
		}, page.index);

		settings.pad_add({
			name: "y_axis_line",
			index_palette: 0,
			// index: index,
			encoders: [
				VOLUME => {
					value: y_axis_line.thick = 200,
					on_change: f -> y_axis_line.thick = Std.int(f),
					name: "thicc ",
					increment: 1,
					minimum: 1,
					// maximum: 10000
				},
				PAN => {
					value: y_axis_line.element.px,// = 50,
					on_change: f -> y_axis_line.element.px = Std.int(f),
					name: "x pivot",
					increment: 1,
					minimum: -10000,
					maximum: 10000
				},
				FILTER => {
					value: y_axis_line.element.px,// = 50,
					on_change: f -> y_axis_line.element.px = Std.int(f),
					name: "y pivot",
					increment: 1,
					minimum: -10000,
					maximum: 10000
				},
				RESONANCE => {
					value: y_axis_line.rotation_override = -45,
					on_change: f -> y_axis_line.rotation_override = f,
					name: "rotation",
					increment: 0.1,
					minimum: -360
				}
			]
		}, page.index);
		
	}

	public function update(elapsed_seconds:Float) {
		mouse_position.x = game.input.mouse_position.x;
		mouse_position.y = game.input.mouse_position.y;
		designer.update_mouse_pointer(mouse_position);
	}

	public function draw() {
		// ?
	}

	function handle_mouse_press_left() {
		if (!designer.isDrawingLine) {
			designer.start_drawing_line({
				x: mouse_position.x,
				y: mouse_position.y
			});
		}
	}

	function handle_mouse_release_left() {
		if (designer.isDrawingLine) {
			designer.stop_drawing_line({
				x: mouse_position.x,
				y: mouse_position.y
			});
			for (line in designer.figure.lines) {
				var l:PeoteLine = cast line;
				l.thick = 8;
			}
		}
	}

	function handle_mouse_press_right() {
		designer.line_under_cursor_remove();
	}
}
