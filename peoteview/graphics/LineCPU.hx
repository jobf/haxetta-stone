package graphics;

import peote.view.Element;
import peote.view.Color;



class Line implements Element {
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Int;
	@sizeY @varying public var h:Int;
	@color @anim("ColorFade") public var color:Color;
	@posX public var x:Int;
	@posY public var y:Int;

	// (rotation offset)
	@pivotX @formula("w * 0.5")public var px:Int = 0;
	@pivotY @formula("w * 0.5") public var py:Int = 0;

	var OPTIONS = {alpha: true};

	// params for blinking alpha
	// @custom("alpha") @varying @anim("A", "pingpong") public var alpha:Float;
	@custom("alpha") @varying @constEnd(1.0) @anim("A", "pingpong") public var alpha:Float;

	public function new(positionX:Float, positionY:Float, width:Float, height:Float, rotation:Float = 0, color:Color = 0x556677ff) {
		this.x = Std.int(positionX);
		this.y = Std.int(positionY);
		this.w = Std.int(width);
		this.h = Std.int(height);
		this.color = color;
		this.rotation = rotation;
	}

	public function setFlashing(isFlashing:Bool) {
		// todo - adhere to previously set alpha
		if (isFlashing) {
			alphaStart = 0.0;
			// animate Color from red to yellow
			animColorFade(Color.RED, Color.GREEN);
			timeColorFade(0.0, 1.0); // from start-time (0.0) and during 1 seconds
		} else {
			alphaStart = 1.0;
		}
	}
}
