package graphics;

import peote.view.Color;
import peote.view.Element;


class Sprite implements Element {
	@pivotX @formula("w * 0.5 + px_offset") public var px_offset:Float;
	@pivotY @formula("h * 0.5 + py_offset") public var py_offset:Float;
	@rotation public var rotation:Float;

	@posX public var x:Int=0;
	@posY public var y:Int=0;

	@sizeX public var w:Int;

	@sizeY public var h:Int;

	var OPTIONS = {alpha: true};

	@color public var c:Color;

	public function new(positionX:Int = 0, positionY:Int = 0, width:Int, height:Int, tile:Int = 0, tint:Color = 0xffffffFF, isVisible:Bool = true) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		c = tint;
	}
}