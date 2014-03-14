package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.lifecycle.IDisposable;

	public class ValueProvider implements IProvider, IValueProvider, IDisposable
	{
		private var _value:*;
		
		/**
		 * @param value The value the provider will provide
		 */
		public function ValueProvider(value:*) 
		{
			_value = value;
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IValueProvider */
		
		public function get value():* 
		{
			return _value;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			_value = null;
		}
		
		/* INTERFACE orichalcum.alchemist.guise.IProvider */
		
		public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*
		{
			return _value;
		}
		
		public function destroy(provision:*):* 
		{
			return provision;
		}
		
		
	}

}
