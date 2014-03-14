package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;

	public class SymbiotProcessor implements IIngredientProcessor
	{
		
		private var _key:String = 'symbiots';
		
		public function SymbiotProcessor() 
		{
			// nothing
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
		{
			// nothing
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const friends:Array = (parentRecipe[_key] ||= []);
			for each(var friend:* in childRecipe[_key])
			{
				if (friends.indexOf(friend) < 0)
				{
					friends.push(friend);
				}
			}
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
	}

}