import sys.FileSystem;
import sys.io.File;
import json2object.*;
import Models;

@:structInit
class FileModel {
	public var models:Array<Model>;
}

class Disk {
	public static function file_write_models(models:Array<Model>, file_path:String):Void {
		var file:FileModel = {
			models: models
		}

		var writer = new JsonWriter<FileModel>();
		var json:String = writer.write(file);

		File.saveContent(file_path, json);
	}

	public static function file_read(file_path:String):FileModel {
		if(FileSystem.exists(file_path)){
			var json:String = File.getContent(file_path);
			var errors = new Array<Error>();
			var data = new JsonParser<FileModel>(errors).fromJson(json, file_path + 'errors');
			if(errors.length <= 0){
				return data;
			}
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
