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

class Ui {
	var sliders:Array<Slider> = [];
	var graphics:GraphicsCore;

	public function new(graphics:GraphicsCore) {
		this.graphics = graphics;
	}

	public function make_slider(geometry:RectangleGeometry, label:String, color:RGBA):Slider {
		return sliders.pushAndReturn(new Slider(geometry, label, color, graphics));
	}

	public function handle_mouse_click(x_mouse:Int, y_mouse:Int) {
		for (slider in sliders) {
			if (slider.overlaps_handle(x_mouse, y_mouse)) {
				slider.click();
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
