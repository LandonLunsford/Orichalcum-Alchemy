package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	
	public interface IDependencyResolver 
	{
		
		/**
		 * Use this as mechanism for hooking conjure unmapped
		 * to look up named values in resource files
		 * [Inject("my.message.in.bundle")]
		 */
		 
		function resolves(id:String, mapping:*):Boolean;
		
		function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):*;
		
	}

}