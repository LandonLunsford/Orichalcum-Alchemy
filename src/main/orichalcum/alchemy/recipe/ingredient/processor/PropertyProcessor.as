package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.utility.ObjectUtil;

	public class PropertyProcessor 
	{
		private var _metatagName:String;
		private var _key:String = 'properties';
		
		public function PropertyProcessor() 
		{
			_metatagName = metatagName ? metatagName : 'Inject';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
		{
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
					recipe.properties[propertyName] = reference(propertyInjections.arg[0].@value.toString());
				}
				else if (reflector.isComplexType(propertyType)) 
				{
					recipe.properties[propertyName] = reference(propertyType);
				}
				if (propertyInjections.length() > 1 || propertyInjections.arg.length() > 1)
				{
					throw new AlchemyError('Multiple "[{0}]" metatags defined for property "{1}" in class "{2}".', _metatagName, propertyName, typeName);
				}
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			ObjectUtil.extend((parentRecipe[_key] ||= {}), childRecipe[_key]);
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
	}

}