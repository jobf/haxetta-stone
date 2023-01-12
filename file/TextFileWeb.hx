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

	public static function export_content(file_path:String){
		var content = get_content(file_path);
		if(content == null){
			return;
		}

		var blob = new js.html.Blob([content]);
		var url = js.html.URL.createObjectURL(blob);
		var anchor = js.Browser.document.createAnchorElement();
		anchor.href = url;
		anchor.download = file_path;
		anchor.click();
	}
}