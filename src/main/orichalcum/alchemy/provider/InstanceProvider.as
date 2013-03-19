package orichalcum.alchemy.provider 
{
	import flash.errors.IllegalOperationError;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;

	public class InstanceProvider implements IInstanceProvider, IDisposable
	{
		private var _type:Class;
		
		public function InstanceProvider(type:Class) 
		{
			if (!type) throw new ArgumentError('InstanceProvider constructor argument "type" may not be null');
			_type = type;
		}
		
		/* INTERFACE orichalcum.lifecylce.IDisposable */
		
		public function dispose():void 
		{
			_type = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):* 
		{
			throw new IllegalOperationError('InstanceProvider.provide() is an abstract method and must be overriden.');
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IInstanceProvider */
		
		public function get type():Class
		{
			return _type;
		}

	}

}