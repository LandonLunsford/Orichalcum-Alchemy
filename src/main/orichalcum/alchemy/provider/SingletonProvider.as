package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;

	public class SingletonProvider extends InstanceProvider
	{
		private var _instance:Object;
		
		public function SingletonProvider(type:Class) 
		{
			super(type);
		}
		
		/* INTERFACE orichalcum.lifecyle.IDisposable */
		
		override public function dispose():void 
		{
			super.dispose();
			_instance = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		override public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*
		{
			return _instance ||= activeAlchemist.create(type, activeRecipe);
		}

	}

}