package orichalcum.alchemy.provider
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.lifecycle.IDisposable;

	public class FactoryProvider implements IProvider, IDisposable
	{
		private var _factoryMethod:Function;
		
		/**
		 * @param factoryMethod The factory method (e.g. function():* or function(activeAlchemist:IAlchemist):*)
		 */
		public function FactoryProvider(factoryMethod:Function)
		{
			if (factoryMethod == null)
				throw new ArgumentError('Argument "factory" passed to "FactoryProvider" constructor must not be null.');
				
			if (factoryMethod.length > 1)
				throw new ArgumentError('Argument "factory" passed to "FactoryProvider" constructor must have between 0 and 1 parameters.');
				
			_factoryMethod = factoryMethod;
		}
		
		public function dispose():void
		{
			_factoryMethod = null;
		}
		
		public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*
		{
			switch (_factoryMethod.length)
			{
				case 0: return _factoryMethod.call(null);
				case 1: return _factoryMethod.call(null, activeAlchemist);
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
