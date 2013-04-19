package subject 
{
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.IProvider;
	
	public class Provider implements IProvider
	{
		static public var provision:*;
		
		public function Provider() 
		{
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return provision;
		}
		
		public function destroy(provision:*):* 
		{
			return provision;
		}
		
	}

}