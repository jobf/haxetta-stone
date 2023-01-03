import lime.utils.AssetType;
import lime.utils.Assets;
import Editor;
import Models;
import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;
import Disk;

using Vector;

class ModelTestScene extends Scene {
	var model_translation:EditorTranslation;
	var model_index:Int = 0;
	var file:FileModel;
	var lines:Array<AbstractLine> = [];

	public function init() {
		game.input.mouse_cursor_hide();
		model_translation = new EditorTranslation(bounds, 1, 1);
		for (s in Assets.list(AssetType.TEXT)) {
			trace(s);
		}
		var models_json = Assets.getText('assets/alphabet-01.json');

		file = Disk.parse_file_contents(models_json);

		var actions:Map<Button, Action> = [
			KEY_LEFT => {
				on_pressed: () -> {
					var next = model_index - 1;
					model_index = (next % file.models.length + file.models.length) % file.models.length;
					draw_model();
				}
			},
			KEY_RIGHT => {
				on_pressed: () -> {
					var next = model_index + 1;
					model_index = (next % file.models.length + file.models.length) % file.models.length;
					draw_model();
				}
			}
		];

		game.input.on_pressed = button -> {
			if (actions.exists(button)) {
				actions[button].on_pressed();
			}
		}

		game.input.on_released = button -> {
			if (actions.exists(button)) {
				actions[button].on_released();
			}
		}

		draw_model();
	}

	function draw_model(){
		var i = lines.length;
		while (i-- > 0) {
			lines[i].erase();
			lines.remove(lines[i]);
		}
		var char = file.models[model_index];

		for (line in char.lines) {
			var from = model_translation.model_to_view_point(line.from);
			var to = model_translation.model_to_view_point(line.to);
			lines.push(game.graphics.make_line(from.x, from.y, to.x, to.y, 0x2C8D49ff));
		}
	}

	public function update(elapsed_seconds:Float) {
	}

	public function draw() {
	}

}
