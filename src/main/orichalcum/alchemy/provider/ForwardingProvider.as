package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class ForwardingProvider extends SingletonProvider
	{
		
		public function ForwardingProvider(providerType:Class) 
		{
			super(providerType);
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		override public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			//return super.provide(activeAlchemist, activeRecipe).provide(activeAlchemist, activeRecipe);
			
			/**
			 * Client providers should not be able to directly communicate to the secure layer
			 */
			return activeAlchemist.conjure(type).provide(activeAlchemist, activeRecipe);
		}
		
	}

}