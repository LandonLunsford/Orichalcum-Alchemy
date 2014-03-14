package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.ingredient.Symbiot;

	public class SymbiotProcessor implements IIngredientProcessor
	{
		
		private var _key:String = 'symbiots';
		private var _friendsByInstance:Dictionary = new Dictionary;
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			/**
			 * Do nothing
			 */
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			const symbiot:Symbiot = ingredient as Symbiot;
			if (symbiot)
			{
				(recipe[_key] ||= []).push(symbiot.id);
			}
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
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var friendId:* in recipe[_key])
			{
				(_friendsByInstance[instance] ||= []).push(alchemist.conjure(friendId));
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const friends:* = _friendsByInstance[instance];
			if (friends)
			{
				for each(var friend:* in friends)
				{
					alchemist.destroy(friend);
				}
				delete _friendsByInstance[instance];
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