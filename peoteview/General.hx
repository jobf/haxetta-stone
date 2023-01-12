class ArrayExtensions{
	public static function all<T>(array:Array<T>, call:T->Void){
		 for(item in array) call(item);
	}

	public static function clear<T>(array:Array<T>, ?call:T->Void=null){
		var index = array.length;
		while(index-- > 0){
			var item = array[index];
			if(call != null){
				call(item);
			}
			array.remove(item);
		}
  }

	public static function firstOrNull<T>(array:Array<T>, should_return_item:T->Bool):T{
		 for(item in array){
			  if(should_return_item(item)) return item;
		 }
		 return null;
	}
	
}