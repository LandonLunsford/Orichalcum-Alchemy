package orichalcum.alchemy.provider
{
	import flash.system.ApplicationDomain;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class FactoryForwardingProvider implements IProvider
	{
		private var _factoryClassName:Object;
		private var _factoryMehtodName:String;
		private var _factoryMethod:Function;
		
		public function FactoryForwardingProvider(factoryMehtodName:String, factoryClassName:Object = null)
		{
			_factoryMehtodName = factoryMehtodName;
			_factoryClassName = factoryClassName;
			
			if (ApplicationDomain.currentDomain.hasDefinition(factoryClassName)
			{
				const factory:Class = ApplicationDomain.currentDomain.getDefinition(factoryClassName);
				if (factoryMethodName in factory)
					_factoryMethod = factory[factoryMehtodName];
			}
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IProvider */
		
		public function provide(activeAlchemist:IAlchemist, activeRecipe:Recipe):*
		{
			if (_factoryMethod == null)
			{
				const factory:* = activeAlchemist.conjure(factoryClassName);
				
				if (!(_factoryMehtodName in factory))
					throw new AlchemyError('Factory method "{0}" not found on factory "{1}."', _factoryMehtodName, factory);
					
				_factoryMethod = factory[_factoryMehtodName];
			}
			
			switch (_factoryMethod.length)
			{
				case 0: return _factoryMethod.call(null);
				case 1: return _factoryMethod.call(null, activeAlchemist);
			}
		}
		
		public function destroy(provision:*):*
		{
			return provision;
		}
		
	}

}
