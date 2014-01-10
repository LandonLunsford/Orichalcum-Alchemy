package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class PrototypeProvider extends InstanceProvider
	{
		/**
		 * @param type The class of the prototype
		 */
		public function PrototypeProvider(type:Class)
		{
			super(type);
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		override public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return activeAlchemist.create(type, activeRecipe, id);
		}
		
	}

}
