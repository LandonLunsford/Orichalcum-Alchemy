package orichalcum.alchemy.metatag 
{

	public class PreDestroyMetatag implements IPreDestroyMetatag
	{
		private var _name:String;
		
		public function PreDestroyMetatag(name:String = 'PreDestroy') 
		{
			_name = name;
		}
		
		/* INTERFACE orichalcum.alchemy.metatag.IPreDestroyMetatag */
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}
