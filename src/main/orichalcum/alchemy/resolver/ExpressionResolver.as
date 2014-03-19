package orichalcum.alchemy.resolver 
{

	/**
	 * @author Landon Lunsford
	 */

	public class ExpressionResolver implements IDependencyResolver 
	{
		
		public function ExpressionResolver() 
		{
			
		}
		
		/* INTERFACE orichalcum.alchemy.resolver.IDependencyResolver */
		
		public function resolves(id:String):Boolean 
		{
			return alchemist.getProvider(id) is String && true // etc
		}
		
		public function resolve(id:String):* 
		{
			
		}
		
	}

}