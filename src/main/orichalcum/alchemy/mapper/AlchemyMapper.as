package orichalcum.alchemy.mapper 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.handler.EventHandler;
	import orichalcum.alchemy.provider.factory.pool;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.provider.factory.singleton;
	import orichalcum.alchemy.provider.factory.type;
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.reflection.IReflector;
	import orichalcum.utility.StringUtil;

	public class AlchemyMapper implements IAlchemyMapper
	{
		private var _reflector:IReflector;
		private var _id:String;
		private var _providers:Dictionary;
		private var _recipes:Dictionary;
		private var _recipe:Recipe;
		private var _constructorArgumentIndex:int;
		
		
		public function AlchemyMapper(reflector:IReflector, id:String, providers:Dictionary, recipes:Dictionary) 
		{
			_reflector = reflector;
			_id = id;
			_providers = providers;
			_recipes = recipes;
		}
		
		/* INTERFACE orichalcum.alchemy.mapper.IMapper */
		
		public function to(providerValueOrReference:*):IAlchemyMapper
		{
			_providers[_id] && onProviderOverwrite(_id);
			_providers[_id] = providerValueOrReference;
			return this;
		}
		
		public function toValue(any:*):IAlchemyMapper
		{
			return to(value(any));
		}
		
		public function toReference(id:*):IAlchemyMapper
		{
			return to(reference(id));
		}
		
		public function asPrototype():IAlchemyMapper
		{
			return toPrototype(getClass(_id));
		}
		
		public function toPrototype(clazz:Class):IAlchemyMapper
		{
			return to(type(clazz));
		}
		
		public function asSingleton():IAlchemyMapper
		{
			return toSingleton(getClass(_id));
		}
		
		public function toSingleton(type:Class):IAlchemyMapper
		{
			return to(singleton(type));
		}
		
		public function asPool():IAlchemyMapper
		{
			return toPool(getClass(_id));
		}
		
		public function toPool(type:Class):IAlchemyMapper
		{
			return to(pool(type));
		}
		
		public function withConstructorArguments(...args):IAlchemyMapper 
		{
			for (var i:int = 0; i < args.length; i++)
				withConstructorArgument(args[i], i);
			return this;
		}
		
		public function withConstructorArgument(value:*, index:int = -1):IAlchemyMapper 
		{
			if (index < 0 || index >= _constructorArgumentIndex)
				index = _constructorArgumentIndex++;
				
			recipe.constructorArguments[index] = value;
			return this;
		}
		
		public function withProperties(properties:Object):IAlchemyMapper 
		{
			for (var propertyName:String in properties)
				withProperty(propertyName, properties[propertyName]);
			return this;
		}
		
		public function withProperty(name:String, value:*):IAlchemyMapper 
		{
			recipe.properties[name] = value;
			return this;
		}
		
		public function withPostConstruct(value:String):IAlchemyMapper 
		{
			recipe.postConstruct = value;
			return this;
		}
		
		public function withPreDestroy(value:String):IAlchemyMapper 
		{
			recipe.preDestroy = value;
			return this;
		}
		
		public function withEventHandler(type:String, listener:String, target:String = null, useCapture:Boolean = false, priority:uint = 0, stopPropagation:Boolean = false, stopImmediatePropagation:Boolean = false):IAlchemyMapper 
		{
			recipe.eventHandlers.push(new EventHandler(type, listener, target, priority, useCapture, stopPropagation, stopImmediatePropagation));
			return this;
		}
		
		/* PRIVATE PARTS */
		
		private function get recipe():Recipe
		{
			if (_recipe)
				return _recipe;
			
			if (_id in _recipes)
			{
				onRecipeOverwrite(_id);
				return _recipe = _recipes[_id].empty();
			}
			return _recipes[_id] = _recipe = new Recipe;
		}
		
		private function getClass(id:String):Class 
		{
			if (_reflector.isType(id))
				return _reflector.getType(id);
				
			throw new AlchemyError('Argument "id" ({0}) passed to method "map" must represent a valid public class when using the "asPrototype|asSingleton|asMultiton" methods.', id);
		}
		
		private function onProviderOverwrite(id:String):void
		{
			throwWarning('[WARNING] Provider for "{0}" has been overwritten.', id);
		}
		
		private function onRecipeOverwrite(id:String):void
		{
			throwWarning('[WARNING] Recipe for "{0}" has been overwritten.', id);
		}
		
		private function throwWarning(message:String, ...substitutions):void
		{
			/**
			 * An option to control this centrally would be for the mapper to
			 * escalate the issue up the responsibility chain with an event
			 * dispatched on a provided eventDispatcher bus. Perhaps in a strict mode
			 * I could throw an error when overwrites occur.
			 */
			trace(StringUtil.substitute(message, substitutions));
		}

	}

}
