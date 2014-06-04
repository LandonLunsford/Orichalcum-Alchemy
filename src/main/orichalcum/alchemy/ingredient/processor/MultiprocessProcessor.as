package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.lifecycle.IAlchemyLifecycle;
	
	public class MultiprocessProcessor implements IAlchemyLifecycle
	{
		private var _processors:Array;
		
		public function MultiprocessProcessor(processors:Array) 
		{
			_processors = processors;
		}
		
		public function get processors():Array
		{
			return _processors;
		}
		
		public function set processors(value:Array):void
		{
			_processors = value;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.introspect(typeName, typeDescription, recipe, alchemist);
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.add(recipe, ingredient);
			}
		}
		
		public function inherit(to:Dictionary, from:Dictionary):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.inherit(to, from);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.activate(instance, recipe, alchemist);
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for (var i:int = _processors.length - 1; i >= 0; i--)
			{
				_processors[i].deactivate(instance, recipe, alchemist);
			}
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.provide(instance, recipe, alchemist);
			}
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			for each(var processor:IIngredientProcessor in _processors)
			{
				processor.configure(xml, alchemist);
			}
		}
		
	}

}