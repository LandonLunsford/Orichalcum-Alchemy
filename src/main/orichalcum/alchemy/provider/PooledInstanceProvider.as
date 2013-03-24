package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.alchemy.alchemist.IAlchemist;

	/**
	 * This class will require the Alchemist to keep a conjuredInstance to Provider map in order to
	 * Track if the instance was generated from this provider so that it may return it upon destruction
	 */
	public class PooledInstanceProvider extends InstanceProvider implements IPooledInstanceProvider
	{
		
		private var _pool:Array;
		
		public function PooledInstanceProvider(type:Class) 
		{
			super(type);
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IPooledInstanceProvider */
		
		public function returnInstance(instance:*):void 
		{
			pool[pool.length] = instance;
		}
		
		override public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return pool.length
				? activeAlchemist.inject(pool.pop())
				: super.provide(activeAlchemist, activeRecipe);
		}
		
		/* PRIVATE PARTS */
		
		private function get pool():Array
		{
			return _pool ||= [];
		}
		
	}

}