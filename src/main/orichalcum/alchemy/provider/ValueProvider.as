package orichalcum.alchemy.provider 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;

	public class ValueProvider implements IProvider, IValueProvider, IDisposable
	{
		private var _value:*;
		
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
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*
		{
			/**
			 * What I really want is _reflector.isPrimitive(_reflector.getTypeName(_value))
			 * currently I am enabling type "Object" for testing purposes? I should rewrite the test
			 * and disallow type Object I think.
			 */
			return !(_value is Object)
				|| _value is Number
				|| _value is String
				|| _value is Class
				|| _value is Function
					? _value
					: activeAlchemist.inject(_value, activeRecipe);
		}
		
	}

}
