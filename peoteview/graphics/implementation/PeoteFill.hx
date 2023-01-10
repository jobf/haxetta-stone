package graphics.implementation;

import graphics.implementation.Graphics;
import graphics.Fill;

import GraphicsAbstract;

class PeoteFill extends AbstractFillRectangle {
	var element:Rectangle;

	public function new(element:Rectangle) {
		super(element.x, element.y, element.w, element.h, cast element.color);
		this.element = element;
	}

	public function draw() {
		element.x = x;
		element.y = y;
		element.w = width;
		element.h = height;
	}
}