import js.Browser;

class TextFileWeb{
	public static function save_content(file_path:String, content:String){
		
		Browser.window.localStorage.setItem(file_path, content);
	}
	
	public static function get_content(file_path:String){
		var content = Browser.window.localStorage.getItem(file_path);
		if(content == null){
			return "";
		}
		return content;
	}
}