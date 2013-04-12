package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class ForwardingProvider implements IProvider
	{
		private var _providerId:*;
		private var _provider:IProvider;
		
		/**
		 * @param providerId The custom ID, Class or qualifiedClassName of the custom provider
		 */
		public function ForwardingProvider(providerId:*) 
		{
			_providerId = providerId;
			_provider = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			_provider = activeAlchemist.conjure(_providerId, activeRecipe);
			return _provider.provide(activeAlchemist, activeRecipe);
		}
		
		public function destroy(provision:*):* 
		{
			return _provider.destroy(provision);
		}
		
	}

}