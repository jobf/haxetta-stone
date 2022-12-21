package test;

import Editor;
import Engine;
import utest.Test;
import utest.Assert;

using Vector;

class EditorTests extends Test {

	function test_viewport_to_editor_point_center() {
		var viewport:RectangleGeometry = {
			width: 100,
			height: 100
		};

		var editor = new Editor(viewport);

		var position_mouse:Vector = {
			x: 50,
			y: 50
		}

		var position_editor = editor.view_to_editor_point(position_mouse);

		Assert.equals(0, position_editor.x);
		Assert.equals(0, position_editor.y);
	}


	function test_viewport_to_editor_point_min() {
		var viewport:RectangleGeometry = {
			width: 100,
			height: 100
		};

		var points_in_editor_x = 10;
		var points_in_editor_y = 10;
		var editor = new Editor(viewport, points_in_editor_x, points_in_editor_y);

		var position_mouse:Vector = {
			x: 0,
			y: 0
		}

		var position_editor = editor.view_to_editor_point(position_mouse);

		Assert.equals(-5, position_editor.x);
		Assert.equals(-5, position_editor.y);
	}

	function test_viewport_to_editor_point_max() {
		var viewport:RectangleGeometry = {
			width: 100,
			height: 100
		};

		var points_in_editor_x = 10;
		var points_in_editor_y = 10;
		var editor = new Editor(viewport, points_in_editor_x, points_in_editor_y);

		var position_mouse:Vector = {
			x: 100,
			y: 100
		}

		var position_editor = editor.view_to_editor_point(position_mouse);

		Assert.equals(5, position_editor.x);
		Assert.equals(5, position_editor.y);
	}
}
