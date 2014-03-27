package orichalcum.alchemy.ingredient 
{

	public class Symbiot 
	{
		private var _id:*;
		
		public function Symbiot(id:*) 
		{
			// assert id is a string or class!
			_id = id;
		}
		
		public function get id():* 
		{
			return _id;
		}
		
	}

}