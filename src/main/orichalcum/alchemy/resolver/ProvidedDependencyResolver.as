package orichalcum.alchemy.resolver 
{
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.provider.IProvider;
	
	public class ProvidedDependencyResolver implements IDependencyResolver
	{
		private var _alchemist:Alchemist;
		
		public function ProvidedDependencyResolver(alchemist:Alchemist) 
		{
			_alchemist = alchemist;
		}
		
		public function resolves(id:String):Boolean 
		{
			return alchemist.getProvider(id) is IProvider;
		}
		
		public function resolve(id:String):* 
		{
			const provider:IProvider = alchemist.getProvider(id);
			instance = evaluateWithRecipe(validId, provider, recipe ||= getRecipe(validId));
			(_providersByInstance[instance] = provider);
		}
		
		public function get alchemist():Alchemist 
		{
			return _alchemist;
		}
		
	}

}