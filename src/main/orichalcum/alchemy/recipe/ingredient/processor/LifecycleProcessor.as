package orichalcum.alchemy.recipe.ingredient.processor 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import flash.utils.Dictionary;

	/**
	 * Macro processor?
	 */

	public class LifecycleProcessor implements IIngredientProcessor
	{
		private var _alchemist:IAlchemist;
		
		public function LifecycleProcessor(alchemist:IAlchemist) 
		{
			_alchemist = alchemist;
		}
		
		private function get processors():Array
		{
			return _alchemist.processors;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void 
		{
			
		}
		
		public function inherit(destination:Dictionary, source:Dictionary):void 
		{
			
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			
		}
		
	}

}