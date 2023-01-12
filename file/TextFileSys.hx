import sys.FileSystem;
import sys.io.File;

class TextFileSys{
	public static function save_content(file_path:String, content:String){
		File.saveContent(file_path, content);
	}

	public static function get_content(file_path:String){
		if (FileSystem.exists(file_path)) {
			return File.getContent(file_path);
		}

		return "";
	}
}