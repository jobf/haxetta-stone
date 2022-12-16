import Geometry;
import lime.ui.Window;
import peote.view.*;

class Peote {
	static var lines:Array<Rectangle> = [];
	public static function init(window:Window) {
		peoteview = new PeoteView(window);
		display = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display);

		lineBuffer = new Buffer<Rectangle>(512, 512, true);
		var lineProgram = new Program(lineBuffer);
		display.addProgram(lineProgram);
	}

	public static function update(elapsed_seconds:Float){
		lineBuffer.update();
	}

	public static function draw_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:Color) {
		var a = to_x - from_x;
		var b = to_y - from_y;
		var lineWidth = 1;
		var lineLength = Math.sqrt(a * a + b * b);
		var lineRotation = Math.atan2(from_x - to_x, -(from_y - to_y)) * (180 / Math.PI);
		lines.push(new Rectangle(from_x, from_y, lineWidth, lineLength, lineRotation, color));
		lineBuffer.addElement(lines[lines.length - 1]);
	}

	public static function draw_polygon(vertices:Array<Point>, color:Color) {
		if (vertices.length < 2){
			return;
		}

		for(a in 0...vertices.length){
			var b = a + 1;
			Peote.draw_line(
				vertices[a % vertices.length].x,
				vertices[a % vertices.length].y,
				vertices[b % vertices.length].x,
				vertices[b % vertices.length].y,
				color
			);
		}
	}

	public static function clear() {
		var i = lines.length;
		while (i > 0) {
			var element = lines.pop();
			lineBuffer.removeElement(element);
			i--;
		}
	}

	static var peoteview:PeoteView;
	static var display:Display;
	static var lineBuffer:Buffer<Rectangle>;
}

class Rectangle implements Element {
	@pivotX public var px_offset:Float = 0.0;
	@pivotY public var py_offset:Float = 0.0;
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Float;
	@sizeY @varying public var h:Float;
	@color public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;
	var OPTIONS = {alpha: true};
	public function new(positionX:Float = 0, positionY:Float = 0, width:Float, height:Float, rotation:Float = 3.0, color:Int) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}
}
