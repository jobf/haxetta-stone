import graphics.implementation.PeoteLine;
import graphics.implementation.Graphics;
import Editor;
import Models;
import GraphicsAbstract;
import Controller;
import Engine;
import Disk;
import dials.SettingsController;
import dials.Disk;
import Macros;
import CodePage;
import peote.view.Color;
import graphics.ui.Ui;
import graphics.ui.Ui.Button as ButtonUI;
import Text;
import InputAbstract.Button;
// import akaifirehx.fire.Control.Button as InputButton;

using Vector;

class DesignerScene extends Scene {
	var x_center:Int;
	var y_center:Int;
	var mouse_position:Vector;
	var designer:Designer;
	var x_axis_line:PeoteLine;
	var y_axis_line:PeoteLine;
	var settings:SettingsController;
	var state_file_path:String;
	var divisions_total:Int = 8;
	var viewport_designer:RectangleGeometry;
	public function init() {
		// game.input.mouse_cursor_hide();
		viewport_designer = {
			y: 0,
			x: 0,
			width: bounds.height,
			height: bounds.height
		}

		mouse_position = game.input.mouse_position;
		x_center = Std.int(viewport_designer.width * 0.5);
		y_center = Std.int(viewport_designer.width * 0.5);

		var size_segment = divisions_calculate_size_segment();
		grid_draw(size_segment);

		x_axis_line = cast game.graphics.make_line(0, y_center, viewport_designer.width, y_center, 0xFF85AB10);
		y_axis_line = cast game.graphics.make_line(x_center, 0, x_center, viewport_designer.height, 0xFF85AB10);

		state_file_path = 'code-page-models.json';
		var file = Disk.file_read(state_file_path);
		if (file.models.length == 0) {
			var names_map:Map<CodePage, String> = EnumMacros.nameByValue(CodePage);

			for (i in 0...256) {
				file.models.push({
					index: i,
					name: names_map[i],
					lines: []
				});
			}
		}

		designer = new Designer(size_segment, game.graphics, viewport_designer, file);
		settings_load();
	}

	var lines_grid:Array<AbstractLine> = [];

	function grid_draw(size_segment:Int) {
		if (lines_grid.length > 0) {
			var delete_index = lines_grid.length;
			while (delete_index-- > 0) {
				lines_grid[delete_index].erase();
				lines_grid.remove(lines_grid[delete_index]);
			}
		}
		for (x in 0...Std.int(viewport_designer.width / size_segment)) {
			var x_ = Std.int(x * size_segment);
			lines_grid.push(game.graphics.make_line(x_, 0, x_, viewport_designer.height, 0xD1D76210));
		}
		for (y in 0...Std.int(viewport_designer.height / size_segment)) {
			var y_ = Std.int(y * size_segment);
			lines_grid.push(game.graphics.make_line(0, y_, viewport_designer.width, y_, 0xD1D76210));
		}
	}

	function release() {
		var x_mouse = Std.int(game.input.mouse_position.x);
		var y_mouse = Std.int(game.input.mouse_position.y);
		ui.handle_mouse_release(x_mouse, y_mouse);
		
	}

	function click() {
		var x_mouse = Std.int(game.input.mouse_position.x);
		var y_mouse = Std.int(game.input.mouse_position.y);
		ui.handle_mouse_click(x_mouse, y_mouse);
	}

	var mouse_position_previous:Vector;
	public function update(elapsed_seconds:Float) {
		mouse_position.x = game.input.mouse_position.x;
		mouse_position.y = game.input.mouse_position.y;
		designer.update_mouse_pointer(mouse_position);

		var is_x_mouse_changed = game.input.mouse_position.x != mouse_position_previous.x;
		var is_y_mouse_changed = game.input.mouse_position.y != mouse_position_previous.y;

		if (is_x_mouse_changed || is_y_mouse_changed) {
			mouse_position_previous.x = game.input.mouse_position.x;
			mouse_position_previous.y = game.input.mouse_position.y;
			var x_mouse = Std.int(game.input.mouse_position.x);
			var y_mouse = Std.int(game.input.mouse_position.y);
			ui.handle_mouse_moved(x_mouse, y_mouse);
		}
	}

	public function draw() {
		// ?
	}

	public function close() {
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
		}
	}

	function handle_mouse_press_right() {
		designer.line_under_cursor_remove();
	}

	var text:Text;
	var test:Word;
	var slider:Slider;
	var ui:Ui;
	var fill:AbstractFillRectangle;
	var toggle:Toggle;
	var button:ButtonUI;

	function settings_load() {
		var font = font_load_embedded();
		font.width_model = 18;
		font.height_model = 18;
		font.width_character = 10;

		var color:RGBA = 0xffffffFF;
		text = new Text(font, game.graphics);
		test = text.word_make(30, 200, "TEST", color);

		var width_fill = 40;
		fill = game.graphics.make_fill(300, 300, width_fill, width_fill, 0xff00ffFF);

		ui = new Ui({
			word_make: text.word_make,
			line_make: game.graphics.make_line,
			fill_make: game.graphics.make_fill
		});

		slider = ui.make_slider({
			y: 400,
			x: 640,
			width: 200,
			height: 50 + font.height_model
		}, "WIDTH", color);

		var width_max = 100;
		var width_min = width_fill;
		slider.on_move = f -> fill.width = (width_max * f) + width_min;

		var is_enabled = true;
		toggle = ui.make_toggle({
			y: 480,
			x: 640,
			width: Std.int(font.width_model * 1.3),
			height: 50 + font.height_model
		}, "VISIBLE", color, is_enabled);

		toggle.on_change = b -> fill.color.a = b ? 255 : 0;

		button = ui.make_button({
			y: 580,
			x: 640,
			width: Std.int(font.width_model * 8),
			height: 50 + font.height_model
		}, "COLOUR", 0x000000FF, color);

		button.on_click = () -> fill.color = cast Color.random();
		// todo - make on_pressed an event dispatcher
		game.input.on_pressed.add(button -> switch button {
			case MOUSE_LEFT: click();
			case _:
		});

		// todo - make on_released an event dispatcher
		game.input.on_released.add(button -> switch button {
			case MOUSE_LEFT: release();
			case _:
		});

		mouse_position_previous = {
			x: game.input.mouse_position.x,
			y: game.input.mouse_position.y
		}

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> handle_mouse_press_left(),
				on_released: () -> handle_mouse_release_left()
			},
			MOUSE_RIGHT => {
				on_pressed: () -> handle_mouse_press_right(),
			},
			// MOUSE_MIDDLE => {
			// 	on_pressed: () -> designer.save_state(false),
			// },
			KEY_LEFT => {
				on_pressed: () -> designer.set_active_figure(-1)
			},
			KEY_RIGHT => {
				on_pressed: () -> designer.set_active_figure(1)
			},
			KEY_C => {
				on_pressed: () -> designer.buffer_copy()
			},
			KEY_E => {
				on_pressed: () -> export()
			},
			KEY_V => {
				on_pressed: () -> designer.buffer_paste()
			},
			// KEY_N => {
			// 	on_pressed: () -> designer.add_new_figure()
			// },
			KEY_R => {
				on_pressed: () -> designer.lines_remove(),
			},
			KEY_S => {
				on_pressed: () -> Disk.file_write_models(designer.file.models, state_file_path),
			},
			KEY_O => {
				on_pressed: () -> grid_set_granularity(-1),
			},
			KEY_P => {
				on_pressed: () -> grid_set_granularity(1),
			}

		];

		game.input.on_pressed.add(button -> {
			if (actions.exists(button)) {
				actions[button].on_pressed();
			}
		});

		game.input.on_released.add(button -> {
			if (actions.exists(button)) {
				actions[button].on_released();
			}
		});

		var page:Page = {
			pads: [],
			name: "one",
		}

		settings = new SettingsController(new DiskSys());
		settings.page_add(page);

		var g:Graphics = cast game.graphics;
		@:privateAccess
		var display = g.display;
		display.zoom = 1;
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
		// x_axis_line.rotation_override = 0;
		// settings.pad_add({
		// 	name: "x_axis_line",
		// 	index_palette: 0,
		// 	// index: index,
		// 	encoders: [
		// 		VOLUME => {
		// 			value: x_axis_line.thick = 4,
		// 			on_change: f -> x_axis_line.thick = Std.int(f),
		// 			name: "thicc ",
		// 			increment: 1,
		// 			minimum: 1,
		// 			// maximum: 10000
		// 		},
		// 		PAN => {
		// 			value: x_axis_line.element.px, // = 50,
		// 			on_change: f -> x_axis_line.element.px = Std.int(f),
		// 			name: "x pivot",
		// 			increment: 1,
		// 			minimum: -10000,
		// 			maximum: 10000
		// 		},
		// 		FILTER => {
		// 			value: x_axis_line.element.px, // = 50,
		// 			on_change: f -> x_axis_line.element.px = Std.int(f),
		// 			name: "y pivot",
		// 			increment: 1,
		// 			minimum: -10000,
		// 			maximum: 10000
		// 		},
		// 		// RESONANCE => {
		// 		// 	value: x_axis_line.rotation_override = 0,
		// 		// 	on_change: f -> x_axis_line.rotation_override = f,
		// 		// 	name: "rotation",
		// 		// 	increment: 0.1,
		// 		// 	minimum: -360
		// 		// }
		// 	]
		// }, page.index);

		// settings.pad_add({
		// 	name: "y_axis_line",
		// 	index_palette: 0,
		// 	// index: index,
		// 	encoders: [
		// 		VOLUME => {
		// 			value: y_axis_line.thick = 4,
		// 			on_change: f -> y_axis_line.thick = Std.int(f),
		// 			name: "thicc ",
		// 			increment: 1,
		// 			minimum: 1,
		// 			// maximum: 10000
		// 		},
		// 		PAN => {
		// 			value: y_axis_line.element.px, // = 50,
		// 			on_change: f -> y_axis_line.element.px = Std.int(f),
		// 			name: "x pivot",
		// 			increment: 1,
		// 			minimum: -10000,
		// 			maximum: 10000
		// 		},
		// 		FILTER => {
		// 			value: y_axis_line.element.px, // = 50,
		// 			on_change: f -> y_axis_line.element.px = Std.int(f),
		// 			name: "y pivot",
		// 			increment: 1,
		// 			minimum: -10000,
		// 			maximum: 10000
		// 		},
		// 		RESONANCE => {
		// 			value: y_axis_line.rotation_override = -45,
		// 			on_change: f -> y_axis_line.rotation_override = f,
		// 			name: "rotation",
		// 			increment: 0.1,
		// 			minimum: -360
		// 		}
		// 	]
		// }, page.index);
	}

	function divisions_calculate_size_segment() {
		return Std.int(viewport_designer.height / divisions_total);
	}

	function grid_set_granularity(direction:Int) {
		if (direction > 0) {
			divisions_total = Std.int(divisions_total * 2);
		} else {
			divisions_total = Std.int(divisions_total / 2);
		}
		if (divisions_total < 2) {
			divisions_total = 2;
		}

		var size_segment = divisions_calculate_size_segment();
		grid_draw(size_segment);
		designer.granularity_set(size_segment);
	}

	function export(){
		#if web
		TextFileWeb.export_content(state_file_path);
		#end
	}
}
