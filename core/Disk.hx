import grig.midi.file.event.TextEvent;
#if !web
import TextFileSys as TextFile;
#else
import TextFileWeb as TextFile;
#end

import json2object.*;
import Models;


class Disk {
	public static function file_write_models(models:Array<FigureModel>, file_path:String):Void {
		var file:FileModel = {
			models: models
		}

		var writer = new JsonWriter<FileModel>();
		var json:String = writer.write(file);
		TextFile.save_content(file_path, json);
	}

	public static function file_read(file_path:String):FileModel {
		var json:String = TextFile.get_content(file_path);

		if(json.length > 0){
			return parse_file_contents(json);
		}
		return {
			models: []
		}
	}

	public static function parse_file_contents(json:String):FileModel {
		var errors = new Array<Error>();
		var data = new JsonParser<FileModel>(errors).fromJson(json, 'json-errors');
		if (errors.length <= 0 && data != null && data.models.length > 0) {
			return data;
		}

		return {
			models: [
				// {
				// 	lines: []
				// }
			]
		}
	}
}
