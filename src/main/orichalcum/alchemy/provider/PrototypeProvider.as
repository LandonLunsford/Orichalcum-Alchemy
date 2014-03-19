package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class PrototypeProvider extends InstanceProvider
	{
		/**
		 * @param type The class of the prototype
		 */
		public function PrototypeProvider(type:Class)
		{
			super(type);
		}
		
		override public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):* 
		{
			return activeAlchemist.create(type, activeRecipe, id);
		}
		
	}

}
