package orichalcum.alchemy.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	
	public interface IIngredientProcessor 
	{
		
		function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void;
		
		function add(recipe:Dictionary, ingredient:Object):void;
		
		function inherit(destination:Dictionary, source:Dictionary):void;
		
		function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		
		function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void

		function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void;
		
		function configure(xml:XML, alchemist:IAlchemist):void;
		
	}

}