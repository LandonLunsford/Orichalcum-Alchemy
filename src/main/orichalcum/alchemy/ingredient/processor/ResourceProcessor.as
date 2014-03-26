package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.ingredient.Symbiot;

	/**
	 * This will have to be plugin because of flex dependencies
	 */
	public class ResourceProcessor implements IIngredientProcessor
	{
		
		private var _ingredientId:String = 'resources';
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const symbiot:Symbiot = ingredient as Symbiot;
			if (symbiot)
			{
				(recipe[_ingredientId] ||= []).push(symbiot.id);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const resources:Array = (parentRecipe[_ingredientId] ||= []);
			for each(var resource:* in childRecipe[_ingredientId])
			{
				resources.push(resource);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var resource:* in recipe[_ingredientId])
			{
				
			}
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
			
		}
	}

}