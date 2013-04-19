package orichalcum.alchemy.error 
{
	import orichalcum.utility.StringUtil;

	public class AlchemyError extends Error
	{
		
		public function AlchemyError(message:String = null, ...substitutions) 
		{
			super(StringUtil.substitute(message || '', substitutions));
		}
		
	}

}