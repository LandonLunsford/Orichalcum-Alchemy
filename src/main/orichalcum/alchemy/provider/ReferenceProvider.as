package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;

	public class ReferenceProvider implements IProvider, IDisposable
	{
		private var _reference:String;
		
		public function ReferenceProvider(reference:String) 
		{
			_reference = reference;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			_reference = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*
		{
			/*
			 * not sure where this is useful but I provide it
			 * use case:
			 * 
			 * alchemist.provide('a').using(type(Point));
			 * alchemist.provide('b').using('{a}').withProperty('x',1);
			 * 
			 * now requests for a will have x=1 while those for b will have x=0
			 */
			return activeAlchemist.conjure(_reference, activeRecipe);
		}
		
	}

}
