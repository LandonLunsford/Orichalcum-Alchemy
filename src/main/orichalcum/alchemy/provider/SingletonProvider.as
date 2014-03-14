package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class SingletonProvider extends InstanceProvider
	{
		private var _instance:Object;
		
		/**
		 * @param type The class of the singleton
		 */
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
		
		override public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*
		{
			return _instance ||= activeAlchemist.create(type, activeRecipe, id);
		}

	}

}