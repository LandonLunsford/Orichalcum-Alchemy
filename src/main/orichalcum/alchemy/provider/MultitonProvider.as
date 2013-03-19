package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class MultitonProvider extends InstanceProvider
	{
		private var _pool:Array;
		private var _poolIndex:int;
		
		public function MultitonProvider(type:Class, poolSize:uint = 0) 
		{
			super(type);
			
			if (poolSize > 0)
			{
				_pool = [];
				_pool.length = poolSize;
			}
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		override public function dispose():void 
		{
			super.dispose();
			_pool = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		override public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*
		{
			const nextIndex:int = ++_poolIndex >= _pool.length ? _poolIndex = 0 : _poolIndex;
			return _pool[nextIndex] ||= activeAlchemist.create(type, activeRecipe);
		}
		
	}

}