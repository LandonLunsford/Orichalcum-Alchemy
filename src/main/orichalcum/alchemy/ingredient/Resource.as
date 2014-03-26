package orichalcum.alchemy.ingredient 
{

	public class Resource 
	{
		
		private var _key:String;
		private var _bundle:String;
		
		public function Resource(key:String, bundle:String) 
		{
			_key = key;
			_bundle = bundle;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function get bundle():String 
		{
			return _bundle;
		}
		
	}

}