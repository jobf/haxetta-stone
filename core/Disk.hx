#if !web
import sys.FileSystem;
import sys.io.File;
#end
import json2object.*;
import Models;

@:structInit
class FileModel {
	public var models:Array<FigureModel>;
}

class Disk {
	public static function file_write_models(models:Array<FigureModel>, file_path:String):Void {
		var file:FileModel = {
			models: models
		}

		var writer = new JsonWriter<FileModel>();
		var json:String = writer.write(file);

		#if !web
		File.saveContent(file_path, json);
		#end
	}

	public static function file_read(file_path:String):FileModel {
		var json:String = "";

		#if !web
		if (FileSystem.exists(file_path)) {
			json = File.getContent(file_path);
		}
		#end

		return parse_file_contents(json);
	}

	public static function parse_file_contents(json:String):FileModel {
		var errors = new Array<Error>();
		var data = new JsonParser<FileModel>(errors).fromJson(json, 'json-errors');
		if (errors.length <= 0 && data != null && data.models.length > 0) {
			return data;
		}

		return {
			models: [
				{
					lines: []
				}
			]
		}
	}
}
