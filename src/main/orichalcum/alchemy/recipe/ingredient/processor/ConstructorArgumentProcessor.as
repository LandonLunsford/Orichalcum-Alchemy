package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.recipe.ingredient.ConstructorArgument;
	import orichalcum.alchemy.recipe.ingredient.ConstructorArguments;

	public class ConstructorArgumentProcessor implements IIngredientProcessor
	{
		
		private var _metatagName:String;
		private var _ingredientId:String = 'constructorArguments';
		
		public function ConstructorArgumentProcessor(metatagName:String = 'Inject') 
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const typeFactory:XML = typeDescription.factory[0];
			const constructorParameterTypes:XMLList = typeFactory.constructor.parameter.@type;
			const constructorArgumentInjections:XMLList = typeFactory.metadata.(@name == _metatagName).arg.@value;
			const totalArgumentInjections:int = constructorArgumentInjections.length();
			const totalRequiredConstructorParameters:int = typeFactory.constructor.parameter.(@optional == 'false').length();
			
			for (var i:int = 0; i < totalArgumentInjections; i++)
			{
				(recipe[_ingredientId] ||= [])[i] = reference(constructorArgumentInjections[i].toString());
			}
			for (; i < totalRequiredConstructorParameters; i++)
			{
				(recipe[_ingredientId] ||= [])[i] = reference(constructorParameterTypes[i].toString());
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is ConstructorArgument)
			{
				const constructorArgument:ConstructorArgument = ingredient as ConstructorArgument;
				var recipeConstructorArguments:Array = (recipe[_ingredientId] ||= []);
				const index:int = constructorArgument.index == -1 ? recipeConstructorArguments.length : constructorArgument.index;
				recipeConstructorArguments[index] = constructorArgument.value;
			}
			else if (ingredient is ConstructorArguments)
			{
				const constructorArguments:ConstructorArguments = ingredient as ConstructorArguments;
				recipeConstructorArguments = (recipe[_ingredientId] ||= []);
				for each(var argument:* in constructorArguments.values)
				{
					recipeConstructorArguments.push(argument);
				}
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const childConstructorArguments:Array = childRecipe[_ingredientId];
			if (!childConstructorArguments) return;
			
			for (var i:int = 0; i < childConstructorArguments.length; i++)
			{
				(parentRecipe[_ingredientId] ||= [])[i] = childConstructorArguments[i];
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Do nothing
			 */
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Do nothing
			 */
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