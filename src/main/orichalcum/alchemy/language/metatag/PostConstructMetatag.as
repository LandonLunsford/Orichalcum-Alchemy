package orichalcum.alchemy.language.metatag 
{

	public class PostConstructMetatag implements IPostConstructMetatag
	{
		private var _name:String;
		
		public function PostConstructMetatag(name:String = 'PostConstruct') 
		{
			_name = name;
		}
		
		/* INTERFACE orichalcum.alchemy.metatag.IPostConstructMetatag */
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}
