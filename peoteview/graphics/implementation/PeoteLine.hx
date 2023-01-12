package graphics.implementation;

import graphics.Fill;
import graphics.LineCPU;
import peote.view.Color;
import GraphicsAbstract;
import graphics.implementation.Graphics;

class PeoteLine extends AbstractLine {
	var a:Float = 0;
	var b:Float = 0;

	public var head:Rectangle;
	public var end:Rectangle;

	var remove_from_buffer:PeoteLine->Void;

	public var element(default, null):Line;
	public var rotation_override:Null<Float>;

	public var thick(get, set):Int;

	public function new(point_from:Vector, point_to:Vector, element:Line, remove_from_buffer:PeoteLine->Void, head:Rectangle, end:Rectangle, color:Color) {
		super(point_from, point_to, cast color);
		this.element = element;
		this.remove_from_buffer = remove_from_buffer;
		this.head = head;
		this.end = end;
		thick = 2;
		draw();
	}

	public function draw():Void {
		element.color = cast color;

		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;

		// line thickness
		element.w = thick;

		// line length - note we add the thickness, otherwise so it finishes too short
		element.h = Std.int(Math.sqrt(a * a + b * b)) + thick;

		element.x = Std.int(point_from.x);
		element.y = Std.int(point_from.y);

		element.rotation = rotation_override == null ? Math.atan2(point_from.x - point_to.x,
			-(point_from.y - point_to.y)) * (180 / Math.PI) : rotation_override;

		head.x = point_from.x;
		head.y = point_from.y;
		head.rotation = element.rotation - 45;

		end.x = point_to.x;
		end.y = point_to.y;
		end.rotation = element.rotation - 45;
	}

	public function erase():Void {
		remove_from_buffer(this);
	}

	function get_thick():Int {
		return element.w;
	}

	var cap_offset:Float = 0.3;

	function set_thick(value:Int):Int {
		element.w = value;
		var cap_size = thick * 0;
		this.head.w = cap_size;
		this.head.h = cap_size;
		this.head.color.a = 40;

		this.end.w = cap_size;
		this.end.h = cap_size;
		this.end.color.a = 40;

		return element.w;
	}
}
