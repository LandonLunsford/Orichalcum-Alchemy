package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	/**
	 * This class will require the Alchemist to keep a conjuredInstance to Provider map in order to
	 * Track if the instance was generated from this provider so that it may return it upon destruction
	 */
	public class PooledInstanceProvider extends InstanceProvider
	{
		
		private var _pool:Array;
		
		public function PooledInstanceProvider(type:Class) 
		{
			super(type);
		}
		
		override public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			return pool.length
				? activeAlchemist.inject(pool.pop())
				: activeAlchemist.create(type, activeRecipe, id);
		}
		
		override public function destroy(provision:*):*
		{
			return pool[pool.length] = provision;
		}
		
		/* PRIVATE PARTS */
		
		private function get pool():Array
		{
			return _pool ||= [];
		}
		
	}

}