package orichalcum.alchemy.resolver 
{
	
	public interface IDependencyResolver 
	{
		
		/**
		 * Use this as mechanism for hooking conjure unmapped
		 * to look up named values in resource files
		 * [Inject("my.message.in.bundle")]
		 */
		 
		function resolves(id:String):Boolean;
		
		function resolve(id:String):*;
		
	}

}