function line_thick_intersection(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, width:Float):Array<Float> {
	/// Returns the intersection point of two thick lines (P1->P2 and P2->P3)
	/// This script returns the *outer* coordinate if P1->P2->P3 is orientated counter-clockwise
	///
	/// @param x1
	/// @param y1
	/// @param x2
	/// @param y2
	/// @param x3
	/// @param y3
	/// @param width

	var _ax = x1 - x2;
	var _ay = y1 - y2;
	var _bx = x3 - x2;
	var _by = y3 - y2;
	var _w = width;

	var _a_length = Math.sqrt(_ax * _ax + _ay * _ay);
	var _b_length = Math.sqrt(_bx * _bx + _by * _by);

	if (_a_length == 0) {
		// If P1 == P2...

		if (_b_length == 0) {
			// If P1 == P2 == P3 then return 0,0 because something is suuuuper broken
			return [0, 0];
		} else {
			// Otherwise return the perpendicular to P2->P3
			_b_length = _w / _b_length;
			return [-_by * _b_length, _bx * _b_length];
		}
	}

	_a_length = _w / _a_length;
	_ax *= _a_length;
	_ay *= _a_length;

	if (_b_length == 0) {
		// If P2 == P3 then return the perpendicular to P1->P2
		return [_ay, -_ax];
	}

	// The distance, parallel to An, from the perpendicular point (adjacent to P2) to the point of intersection is 1/tan(Theta/2)
	// Additionally, 1/tan(Theta/2) = [1 + cos(Theta)] / sin(Theta)
	// We use the dot product and cross product to compute cos(Theta) and sin(Theta)
	var _distance = (_w * _b_length + _ax * _bx + _ay * _by) / (_ax * _by - _ay * _bx);

	// Push out perpendicular to vector A, then move backwards along A using the distance
	return [_ay - _distance * _ax, -_ax - _distance * _ay];
}

class ThickLine {
	public function new(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float, width:Float) {
		/// Draws a thick line from x2,y2 to x3,y3
		/// x1,y1 and x4,y4 are specified to ensure cap offsets are correct
		///
		/// If P1 == P2 then the start cap will be perpendicular to P2->P3
		/// If P3 == P4 then the end cap will be perpendicular to P2->P3
		///
		/// Modes:
		/// <= 0 - Filled
		///    1 - Outline
		///    2 - Outline + start cap (at P2)
		///    3 - Outline + end cap (at P3)
		/// >= 4 - Outline + both caps
		///
		/// @param x1
		/// @param y1
		/// @param x2
		/// @param y2
		/// @param x3
		/// @param y3
		/// @param x4
		/// @param y4
		/// @param width
		/// @param mode

		var _x1 = x1;
		var _y1 = y1;
		var _x2 = x2;
		var _y2 = y2;
		var _x3 = x3;
		var _y3 = y3;
		var _x4 = x4;
		var _y4 = y4;
		var _width = width;
		// var _mode = argument9;

		var _a = line_thick_intersection(_x1, _y1, _x2, _y2, _x3, _y3, _width);
		var _ax = _a[0];
		var _ay = _a[1];
		var _b = line_thick_intersection(_x2, _y2, _x3, _y3, _x4, _y4, _width);
		var _bx = _b[0];
		var _by = _b[1];

		var draw_line:(x1:Float, y1:Float, x2:Float, y2:Float)->Void;// = (x1, y1, x2, y2) -> {}
		draw_line(_x2 + _ax, _y2 + _ay, _x3 + _bx, _y3 + _by);
		draw_line(_x2 - _ax, _y2 - _ay, _x3 - _bx, _y3 - _by);
		// if (_mode <= 0) {
		// 	draw_triangle(_x2 + _ax, _y2 + _ay, _x2 - _ax, _y2 - _ay, _x3 + _bx, _y3 + _by, false);

		// 	draw_triangle(_x2 - _ax, _y2 - _ay, _x3 + _bx, _y3 + _by, _x3 - _bx, _y3 - _by, false);
		// } else {
		// 	draw_line(_x2 + _ax, _y2 + _ay, _x3 + _bx, _y3 + _by);
		// 	draw_line(_x2 - _ax, _y2 - _ay, _x3 - _bx, _y3 - _by);

		// 	if (_mode >= 2) {
		// 		if (_mode != 3)
		// 			draw_line(_x2 + _ax, _y2 + _ay, _x2 - _ax, _y2 - _ay);
		// 		if (_mode >= 3)
		// 			draw_line(_x3 + _bx, _y3 + _by, _x3 - _bx, _y3 - _by);
		// 	}
		// }
	}
}
