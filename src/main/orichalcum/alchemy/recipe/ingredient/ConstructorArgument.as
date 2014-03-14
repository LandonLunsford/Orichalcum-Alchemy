package orichalcum.alchemy.recipe.ingredient 
{

	public class ConstructorArgument 
	{
		
		private var _value:*;
		private var _index:int;
		
		public function ConstructorArgument(value:*, index:int = -1) 
		{
			_value = value;
			_index = index;
		}
		
		public function get value():* 
		{
			return _value;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
	}

}