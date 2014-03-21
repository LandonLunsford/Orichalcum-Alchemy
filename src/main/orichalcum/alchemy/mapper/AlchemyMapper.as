package orichalcum.alchemy.mapper 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.processor.IIngredientProcessor;
	import orichalcum.utility.Strings;

	public class AlchemyMapper implements IAlchemyMapper
	{
		
		private var _alchemist:IAlchemist;
		private var _id:String;
		private var _providers:Dictionary;
		private var _recipes:Dictionary;
		private var _recipe:Dictionary;
		
		
		public function AlchemyMapper(alchemist:IAlchemist, id:String, providers:Dictionary, recipes:Dictionary) 
		{
			_alchemist = alchemist;
			_id = id;
			_providers = providers;
			_recipes = recipes;
		}
		
		public function to(providerValueOrReference:*):IAlchemyMapper
		{
			_providers[_id] && onProviderOverwrite(_id);
			_providers[_id] = providerValueOrReference;
			return this;
		}
		
		public function add(...args):IAlchemyMapper
		{
			for each(var potentialIngredient:* in args)
			{
				var argument:* = args[0];
				if (argument is Array)
				{
					return add.apply(null, argument as Array);
				}
				else if (argument)
				{
					_alchemist.lifecycle.add(recipe, argument);
				}
			}
			return this;
		}
		
		/* PRIVATE PARTS */
		
		private function get recipe():Dictionary
		{
			if (_recipe)
			{
				return _recipe;
			}
			if (_id in _recipes)
			{
				onRecipeOverwrite(_id);
				return _recipe = _recipes[_id].empty();
			}
			return _recipes[_id] = _recipe = new Dictionary;
		}
		
		private function getClass(id:String):Class 
		{
			if (_alchemist.reflector.isType(id))
				return _alchemist.reflector.getType(id);
				
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
			trace(Strings.interpolate(message, substitutions));
		}

	}

}
