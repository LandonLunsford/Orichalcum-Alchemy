package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;

	public class FactoryProvider implements IProvider, IDisposable
	{
		
		private var _factory:Function;
		
		/**
		 * @param factory The factory method (e.g. function():* or function(activeAlchemist:IAlchemist):*)
		 */
		public function FactoryProvider(factory:Function) 
		{
			if (factory == null)
				throw new ArgumentError('Argument "factory" passed to "FactoryProvider" constructor must not be null.');
				
			if (factory.length > 1)
				throw new ArgumentError('Argument "factory" passed to "FactoryProvider" constructor must have between 0 and 1 parameters.');
				
			_factory = factory;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void
		{
			_factory = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			switch (_factory.length)
			{
				case 0: return _factory();
				case 1: return _factory(activeAlchemist);
			}
		}
		
		/**
		 * Need to pass a new function to constructor to delegate to
		 */
		public function destroy(provision:*):* 
		{
			return provision;
		}
		
	}

}