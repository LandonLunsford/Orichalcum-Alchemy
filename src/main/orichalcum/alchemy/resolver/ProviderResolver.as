package orichalcum.alchemy.resolver 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.IProvider;
	
	public class ProviderResolver implements IDependencyResolver
	{
		
		public function resolves(id:String, mapping:*):Boolean 
		{
			return mapping is IProvider;
		}
		
		public function resolve(id:String, mapping:*, recipe:Dictionary, alchemist:IAlchemist):* 
		{
			return (mapping as IProvider).provide(id, alchemist, recipe);		
		}
		
	}

}