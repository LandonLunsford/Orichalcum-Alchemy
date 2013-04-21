package orichalcum.alchemy.recipe 
{
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.collection.IList;

	public class NullRecipe extends Recipe
	{
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		override public function dispose():void 
		{
			
		}
		
		override public function clone():Recipe
		{
			return this;
		}
		
		override public function empty():Recipe
		{
			return this;
		}
		
		override public function extend(recipe:Recipe):Recipe
		{
			return recipe;
		}
		
		override public function get hasConstructorArguments():Boolean 
		{
			return false;
		}
		
		override public function get hasProperties():Boolean 
		{
			return false;
		}
		
		override public function get hasComposer():Boolean 
		{
			return false;
		}
		
		override public function get hasDisposer():Boolean 
		{
			return false;
		}
		
		override public function get hasEventHandlers():Boolean 
		{
			return false;
		}
		
		override public function get constructorArguments():IList 
		{
			return null;
		}
		
		override public function set constructorArguments(value:IList):void 
		{
			
		}
		
		override public function get properties():Object 
		{
			return null;
		}
		
		override public function set properties(value:Object):void 
		{
			
		}
		
		override public function get eventHandlers():IList
		{
			return null;
		}
		
		override public function set eventHandlers(value:IList):void 
		{
			
		}
		
		override public function get postConstruct():String 
		{
			return null;
		}
		
		override public function set postConstruct(value:String):void 
		{
			
		}
		
		override public function get preDestroy():String 
		{
			return null;
		}
		
		override public function set preDestroy(value:String):void 
		{
			
		}
		
	}

}
