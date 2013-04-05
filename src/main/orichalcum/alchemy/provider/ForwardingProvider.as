package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	/**
	 * @deprecated
	 */
	public class ForwardingProvider extends SingletonProvider
	{
		/**
		 * @param providerType The class of the custom provider
		 */
		public function ForwardingProvider(providerType:Class) 
		{
			super(providerType);
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		override public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return super.provide(activeAlchemist, activeRecipe).provide(activeAlchemist, activeRecipe);
		}
		
	}

}