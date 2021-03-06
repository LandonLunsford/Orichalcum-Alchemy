package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.Properties;
	import orichalcum.alchemy.ingredient.Property;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.reflection.IReflector;
	import orichalcum.utility.Objects;

	public class PropertyProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _ingredientId:String = 'properties';
		
		public function PropertyProcessor(metatagName:String = 'Inject') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const reflector:IReflector = alchemist.reflector;
			const typeFactory:XML = typeDescription.factory[0];
			const propertyInjectees:XMLList = typeFactory.variable + typeFactory.accessor.(@access != 'readonly');
			
			for each (var propertyInjectee:XML in propertyInjectees)
			{
				var propertyInjections:XMLList = propertyInjectee.metadata.(@name == _metatagName);
				if (propertyInjections.length() == 0) continue;
				
				var propertyName:String = propertyInjectee.@name.toString();
				var propertyType:String = propertyInjectee.@type.toString();
				
				if (propertyInjections.arg.length() > 0)
				{
					(recipe[_ingredientId] ||= {})[propertyName] = reference(propertyInjections.arg[0].@value.toString());
				}
				else if (reflector.isComplexType(propertyType)) 
				{
					(recipe[_ingredientId] ||= {})[propertyName] = reference(propertyType);
				}
				if (propertyInjections.length() > 1 || propertyInjections.arg.length() > 1)
				{
					throw new AlchemyError('Multiple "[{}]" metatags defined for property "{}" in class "{}".', _metatagName, propertyName, typeName);
				}
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is Property)
			{
				const property:Property = ingredient as Property;
				(recipe[_ingredientId] ||= {})[property.name] = property.value;
			}
			else if (ingredient is Properties)
			{
				const properties:Properties = ingredient as Properties;
				for (var name:* in properties.valuesByName)
				{
					(recipe[_ingredientId] ||= {})[name] = properties.valuesByName[name];
				}
			}
		}
		
		public function inherit(to:Dictionary, from:Dictionary):void 
		{
			if (_ingredientId in from)
			{
				Objects.extend((to[_ingredientId] ||= {}), from[_ingredientId]);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			const properties:Object = recipe[_ingredientId];
			for (var propertyName:String in properties)
			{
				instance[propertyName] = alchemist.evaluate(properties[propertyName]);
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for (var propertyName:String in recipe[_ingredientId])
			{
				if (instance[propertyName] is Object)
				{
					instance[propertyName] = null;
				}
			}
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			/**
			 * Do nothing
			 */
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			// process xml bean
		}
	}

}