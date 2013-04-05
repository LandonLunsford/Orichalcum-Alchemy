package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class ForwardingProvider implements IProvider
	{
		private var _providerId:*;
		
		/**
		 * @param providerId The custom ID, Class or qualifiedClassName of the custom provider
		 */
		public function ForwardingProvider(providerId:*) 
		{
			_providerId = providerId;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return activeAlchemist.conjure(_providerId, activeRecipe).provide(activeAlchemist, activeRecipe);
		}
		
		public function destroy(provision:*):* 
		{
			return activeAlchemist.conjure(_providerId, activeRecipe).destroy(provision);
		}
		
	}

}