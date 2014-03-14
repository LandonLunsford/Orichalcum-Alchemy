package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;

	public class SignalHandlerProcessor 
	{
		private var _metatagName:String;
		private var _key:String = 'signalHandlers';
		
		public function SignalHandlerProcessor() 
		{
			_metatagName = metatagName ? metatagName : 'SignalHandler';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
		{
			
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
	}

}