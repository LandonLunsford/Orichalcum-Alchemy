package orichalcum.alchemy.provider
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.lifecycle.IDisposable;

	/**
	 * I don't like the idea of directly calling outward to the ApplicationDomain here
	 * It would be better if this was checked externally at XML configuration parse time
	 * And perhaps I can look ahead to the class method and instance method definitions and catch
	 * errors early.
	 */
	public class FactoryForwardingProvider implements IProvider, IDisposable
	{
		private var _factoryClassNameOrId:String;
		private var _factoryMehtodName:String;
		private var _factoryMethod:Function;
		
		public function FactoryForwardingProvider(factoryMehtodName:String, factoryClassNameOrId:String)
		{
			if (factoryMehtodName == null)
				throw new ArgumentError('Argument "factoryMehtodName" passed to "FactoryForwardingProvider" constructor must not be null.');
			
			if (factoryClassNameOrId == null)
				throw new ArgumentError('Argument "factoryClassName" passed to "FactoryForwardingProvider" constructor must not be null.');
				
			if (factoryMehtodName.length == 0)	
				throw new ArgumentError('Argument "factoryMehtodName" passed to "FactoryForwardingProvider" constructor must not be an empty String.');
			
			if (factoryClassNameOrId.length == 0)	
				throw new ArgumentError('Argument "factoryClassName" passed to "FactoryForwardingProvider" constructor must not be an empty String.');
				
			if (ApplicationDomain.currentDomain.hasDefinition(factoryClassNameOrId))
			{
				const factory:Class = ApplicationDomain.currentDomain.getDefinition(factoryClassNameOrId) as Class;
				if (factoryMehtodName in factory)
					_factoryMethod = factory[factoryMehtodName];
			}
			
			_factoryMehtodName = factoryMehtodName;
			_factoryClassNameOrId = factoryClassNameOrId;
		}

		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			_factoryClassNameOrId = null;
			_factoryMehtodName = null;
			_factoryMethod = null;
		}
		
		/* INTERFACE orichalcum.alchemy.provider.IProvider */
		
		public function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*
		{
			if (_factoryMethod == null)
			{
				const factory:* = activeAlchemist.conjure(_factoryClassNameOrId);
				
				if (!(_factoryMehtodName in factory))
					throw new AlchemyError('Factory method "{0}" not found on factory "{1}".', _factoryMehtodName, factory);
				
				_factoryMethod = factory[_factoryMehtodName];
					
				if (_factoryMethod == null)
					throw new AlchemyError('Factory method "{0}" on factory "{1}" is not a function.', _factoryMehtodName, factory);
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
