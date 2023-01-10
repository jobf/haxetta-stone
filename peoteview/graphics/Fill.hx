package graphics;

import peote.view.Color;
import peote.view.Element;

class Rectangle implements Element {
	@pivotX @formula("w * 0.5 + px_offset") public var px_offset:Float;
	@pivotY @formula("h * 0.5 + py_offset") public var py_offset:Float;
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Float;
	@sizeY @varying public var h:Float;
	@color public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;

	var OPTIONS = {alpha: true};

	public function new(positionX:Float, positionY:Float, width:Float, height:Float, rotation:Float = 0, color:Color = 0x556677ff) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}
}