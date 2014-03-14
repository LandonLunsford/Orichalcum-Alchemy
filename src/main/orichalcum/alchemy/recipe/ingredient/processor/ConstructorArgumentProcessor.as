package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.provider.factory.reference;

	public class ConstructorArgumentProcessor 
	{
		
		private var _metatagName:String;
		private var _key:String = 'constructorArguments';
		
		public function ConstructorArgumentProcessor('Inject') 
		{
			_metatagName = metatagName ? metatagName : 'Inject';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
		{
			const typeFactory:XML = typeDescription.factory[0];
			const constructorParameterTypes:XMLList = typeFactory.constructor.parameter.@type;
			const constructorArgumentInjections:XMLList = typeFactory.metadata.(@name == _metatagName).arg.@value;
			const totalArgumentInjections:int = constructorArgumentInjections.length();
			const totalRequiredConstructorParameters:int = typeFactory.constructor.parameter.(@optional == 'false').length();
			
			for (var i:int = 0; i < totalArgumentInjections; i++)
			{
				(recipe[_key] ||= [])[i] = reference(constructorArgumentInjections[i].toString());
			}
			for (; i < totalRequiredConstructorParameters; i++)
			{
				(recipe[_key] ||= [])[i] = reference(constructorParameterTypes[i].toString());
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const childConstructorArguments:Array = childRecipe[_key];
			for (var i:int = 0; i < childConstructorArguments.length; i++)
			{
				(parentRecipe[_key] ||= [])[i] = childConstructorArguments[i];
			}
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			// nothing
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			// nothing
		}
	}

}