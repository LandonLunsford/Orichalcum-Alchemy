package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;

	public class FactoryProvider implements IProvider, IDisposable
	{
		private var _factory:Function;
		
		public function FactoryProvider(factory:Function) 
		{
			_factory = factory;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void
		{
			_factory = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):Object 
		{
			switch (_factory.length)
			{
				case 0: return _factory();
				case 1: return _factory(activeAlchemist);
				case 2: return _factory(activeAlchemist, activeRecipe);
			}
			throw new Error('InstanceProvider cannot satisfy factory method arguments');
		}
		
	}

}