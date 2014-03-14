package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class SignalHandlerProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _key:String = 'signalHandlers';
		
		public function SignalHandlerProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'SignalHandler';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void
		{
			
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			
		}
		
	}

}