package test;

import utest.Test;
import utest.Assert;

using Vector;

class VectorTests extends Test {
	function test_transform_position() {
		var a:Vector = {
			x: 1,
			y: 1
		}

		var position:Vector = {
			x: 10,
			y: 10
		}

		var scale = 1;
		var rotation = 0;

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);

		var transformed = a.vector_transform(scale, position.x, position.y, rotation_sin, rotation_cos);

		Assert.equals(transformed.x, a.x + position.x);
		Assert.equals(transformed.y, a.y + position.y);

	}
}
