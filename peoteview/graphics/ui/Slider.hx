package graphics.ui;

import Engine;
import Text;
import GraphicsAbstract;

@:structInit
class GraphicsCore {
	public var word_make:MakeWord;
	public var line_make:MakeLine;
	public var fill_make:MakeFillRectangle;
}

class Slider {
	var label:Word;
	var track:AbstractLine;
	var handle:AbstractFillRectangle;

	public var is_dragging(default, null):Bool;
	public var x(get, never):Int;
	public var x_min(get, never):Int;
	public var x_max(get, never):Int;
	public var on_move:Float->Void = f -> trace('on_move $f');

	public function new(geometry:RectangleGeometry, label:String, color:RGBA, graphics:GraphicsCore) {
		this.label = graphics.word_make(geometry.x, geometry.y, label, color);
		var y_track = geometry.y + Std.int(geometry.height * 0.5);
		this.track = graphics.line_make(geometry.x, y_track, geometry.x + geometry.width, y_track, color);
		var size_handle = Std.int(geometry.height * 0.3);
		this.handle = graphics.fill_make(geometry.x, y_track, size_handle, size_handle, color);
		is_dragging = false;
	}

	public function overlaps_handle(x_mouse:Int, y_mouse:Int) {
		x_mouse = Std.int(x_mouse + handle.width * 0.5);
		y_mouse = Std.int(y_mouse + handle.height * 0.5);

		var x_overlaps = x_mouse > handle.x && handle.x + handle.width > x_mouse;
		var y_overlaps = y_mouse > handle.y && handle.y + handle.height > y_mouse;
		return x_overlaps && y_overlaps;
	}

	public function click() {
		is_dragging = true;
		trace('click!');
	}

	public function release() {
		is_dragging = false;
		trace('!click');
	}

	public function drag(direction:Int) {
		handle.x += direction;
	}

	function get_x():Int {
		return Std.int(handle.x);
	}

	public function move(x_mouse:Int) {
		handle.x = x_mouse;
		var x_proportional = handle.x - track.point_from.x;
		on_move(x_proportional / track.length);
	}

	function get_x_min():Int {
		return Std.int(track.point_from.x);
	}

	function get_x_max():Int {
		return Std.int(track.point_from.x + track.length);
	}
}


class Toggle {
	var label:Word;
	var track:AbstractLine;
	var handle:AbstractFillRectangle;

	public var is_enabled(default, null):Bool;
	public var on_change:Bool->Void = b -> trace('on_change $b');

	public function new(geometry:RectangleGeometry, label:String, color:RGBA, graphics:GraphicsCore, is_enabled:Bool) {
		this.label = graphics.word_make(geometry.x, geometry.y, label, color);
		var y_track = geometry.y + Std.int(geometry.height * 0.5);
		this.track = graphics.line_make(geometry.x, y_track, geometry.x + geometry.width, y_track, color);
		var size_handle = Std.int(geometry.height * 0.3);
		this.handle = graphics.fill_make(geometry.x, y_track, size_handle, size_handle, color);
		this.is_enabled = is_enabled;
		handle_move();
	}

	public function overlaps_handle(x_mouse:Int, y_mouse:Int) {
		x_mouse = Std.int(x_mouse + handle.width * 0.5);
		y_mouse = Std.int(y_mouse + handle.height * 0.5);

		var x_overlaps = x_mouse > handle.x && handle.x + handle.width > x_mouse;
		var y_overlaps = y_mouse > handle.y && handle.y + handle.height > y_mouse;
		return x_overlaps && y_overlaps;
	}

	public function click() {
		is_enabled = !is_enabled;
		handle_move();
		on_change(is_enabled);
	}

	inline function handle_move() {
		var x_handle = is_enabled ? track.point_to.x : track.point_from.x;
		handle.x = x_handle;
	}
}

class Button {
	var label:Word;
	var track:AbstractLine;
	var background:AbstractFillRectangle;

	public var on_click:Void->Void = () -> trace('on_click');

	public function new(geometry:RectangleGeometry, label:String, color_text:RGBA, color_background:RGBA, graphics:GraphicsCore) {
		var x_center = Std.int(geometry.width * 0.5);
		var x_background = Std.int(geometry.x + x_center);
		var y_background = Std.int(geometry.y + geometry.height * 0);
		this.background = graphics.fill_make(x_background, y_background, geometry.width, geometry.height, color_background);

		// var width_label = label.length * 14;
		// var width_label_center = width_label * 0.5;
		// var width_char_center = 7;
		// var x_label = Std.int(geometry.x + x_center - width_label_center + width_char_center);
		this.label = graphics.word_make(geometry.x, geometry.y, label, color_text, x_center);
	}

	public function overlaps_background(x_mouse:Int, y_mouse:Int) {
		x_mouse = Std.int(x_mouse + background.width * 0.5);
		y_mouse = Std.int(y_mouse + background.height * 0.5);

		var x_overlaps = x_mouse > background.x && background.x + background.width > x_mouse;
		var y_overlaps = y_mouse > background.y && background.y + background.height > y_mouse;
		return x_overlaps && y_overlaps;
	}

	public function click() {
		on_click();
	}
}

class Ui {
	var sliders:Array<Slider> = [];
	var toggles:Array<Toggle> = [];
	var buttons:Array<Button> = [];
	var graphics:GraphicsCore;

	public function new(graphics:GraphicsCore) {
		this.graphics = graphics;
	}

	public function make_slider(geometry:RectangleGeometry, label:String, color:RGBA):Slider {
		return sliders.pushAndReturn(new Slider(geometry, label, color, graphics));
	}

	public function make_toggle(geometry:RectangleGeometry, label:String, color:RGBA, is_enabled:Bool):Toggle {
		return toggles.pushAndReturn(new Toggle(geometry, label, color, graphics, is_enabled));
	}

	public function make_button(geometry:RectangleGeometry, label:String, color_text:RGBA, color_background:RGBA):Button {
		return buttons.pushAndReturn(new Button(geometry, label, color_text, color_background, graphics));
	}

	public function handle_mouse_click(x_mouse:Int, y_mouse:Int) {
		for (slider in sliders) {
			if (slider.overlaps_handle(x_mouse, y_mouse)) {
				slider.click();
			}
		}

		for (toggle in toggles) {
			if (toggle.overlaps_handle(x_mouse, y_mouse)) {
				toggle.click();
			}
		}

		for(button in buttons){
			if (button.overlaps_background(x_mouse, y_mouse)) {
				button.click();
			}
		}
	}

	public function handle_mouse_release(x_mouse:Int, y_mouse:Int) {
		for (slider in sliders) {
			slider.release();
		}
	}

	public function handle_mouse_moved(x_mouse:Int, y_mouse:Int) {
		for (slider in sliders) {
			if (slider.is_dragging) {
				if (x_mouse != slider.x) {
					if (x_mouse > slider.x_min && x_mouse < slider.x_max) {
						slider.move(x_mouse);
					}
				}
			}
		}
	}
}
