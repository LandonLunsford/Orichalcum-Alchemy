package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.recipe.ingredient.Property;
	import orichalcum.reflection.IReflector;
	import orichalcum.utility.ObjectUtil;

	public class PropertyProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _key:String = 'properties';
		
		public function PropertyProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'Inject';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
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
					(recipe[_key] ||= {})[propertyName] = reference(propertyInjections.arg[0].@value.toString());
				}
				else if (reflector.isComplexType(propertyType)) 
				{
					(recipe[_key] ||= {})[propertyName] = reference(propertyType);
				}
				if (propertyInjections.length() > 1 || propertyInjections.arg.length() > 1)
				{
					throw new AlchemyError('Multiple "[{0}]" metatags defined for property "{1}" in class "{2}".', _metatagName, propertyName, typeName);
				}
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const property:Property = ingredient as Property;
			if (property)
			{
				(recipe[_key] ||= {})[property.name] = property.value;
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			ObjectUtil.extend((parentRecipe[_key] ||= {}), childRecipe[_key]);
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			const properties:Object = recipe[_key];
			for (var propertyName:String in properties)
			{
				instance[propertyName] = alchemist.evaluate(properties[propertyName]);
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for (var propertyName:String in recipe[_key])
			{
				if (instance[propertyName] is Object)
				{
					instance[propertyName] = null;
				}
			}
		}
		
	}

}