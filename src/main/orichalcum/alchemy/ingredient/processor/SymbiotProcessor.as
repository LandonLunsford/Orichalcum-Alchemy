package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.ingredient.Symbiot;

	public class SymbiotProcessor implements IIngredientProcessor
	{
		
		private var _ingredientId:String = 'symbiots';
		private var _symbiotsByInstance:Dictionary = new Dictionary;
		
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
				(recipe[_ingredientId] ||= []).push(symbiot.id);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			const friends:Array = (parentRecipe[_ingredientId] ||= []);
			for each(var friend:* in childRecipe[_ingredientId])
			{
				if (friends.indexOf(friend) < 0)
				{
					friends.push(friend);
				}
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var symbiotId:* in recipe[_ingredientId])
			{
				(_symbiotsByInstance[instance] ||= []).push(alchemist.conjure(symbiotId));
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const friends:* = _symbiotsByInstance[instance];
			if (friends)
			{
				for each(var friend:* in friends)
				{
					alchemist.destroy(friend);
				}
				delete _symbiotsByInstance[instance];
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