package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.recipe.ingredient.ConstructorArgument;

	public class ConstructorArgumentProcessor implements IIngredientProcessor
	{
		
		private var _metatagName:String;
		private var _key:String = 'constructorArguments';
		
		public function ConstructorArgumentProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'Inject';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
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
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const constructorArgument:ConstructorArgument = ingredient as ConstructorArgument;
			if (constructorArgument)
			{
				const constructorArguments:Array = (recipe[_key] ||= []);
				constructorArguments[
					constructorArgument.index == -1
					? constructorArguments.length
					: constructorArgument.index
				] = constructorArgument.value;
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const childConstructorArguments:Array = childRecipe[_key];
			if (!childConstructorArguments) return;
			
			for (var i:int = 0; i < childConstructorArguments.length; i++)
			{
				(parentRecipe[_key] ||= [])[i] = childConstructorArguments[i];
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			// nothing
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			// nothing
		}
	}

}