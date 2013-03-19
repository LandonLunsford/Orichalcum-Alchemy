package orichalcum.alchemy.metatag 
{

	public class InjectionMetatag implements IInjectionMetatag
	{
		private var _name:String;
		
		public function InjectionMetatag(name:String = 'Inject') 
		{
			_name = name;
		}
		
		/* INTERFACE orichalcum.alchemy.metatag.IInjectionMetatag */
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}