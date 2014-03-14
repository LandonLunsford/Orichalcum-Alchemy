package orichalcum.alchemy.error 
{
	import orichalcum.utility.Strings;

	public class AlchemyError extends Error
	{
		
		public function AlchemyError(message:String = null, ...substitutions) 
		{
			super(Strings.interpolate(message || '', substitutions));
		}
		
	}

}