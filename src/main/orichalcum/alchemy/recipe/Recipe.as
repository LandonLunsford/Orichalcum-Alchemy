package orichalcum.alchemy.recipe 
{
	import org.flexunit.runner.manipulation.IFilter;
	import orichalcum.alchemy.handler.IEventHandler;
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.utility.ObjectUtil;

	/**
	 * Recipe can be furthur decomposed into
	 * 1. constructor ingredients
	 * 2. property ingredients
	 * 3. lifecycle ingredients
	 * 4. event handler ingredients
	 * If I lazily create these recipe components separatly I could potentially
	 * save runtime evaluation complexity for users who do not utilize these features
	 */
	public class Recipe implements IDisposable
	{
		private var _constructorArguments:Array;
		private var _properties:Object;
		private var _eventHandlers:Array;
		private var _postConstruct:String;
		private var _preDestroy:String;
		private var _friends:Array;
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			for each(var disposable:IDisposable in _constructorArguments)
				disposable && disposable.dispose();
			
			for each(disposable in _eventHandlers)
				disposable && disposable.dispose();
				
			for (var disposableName:String in _properties)
				_properties[disposableName] is IDisposable && (_properties[disposableName] as IDisposable).dispose();
				
			_constructorArguments = null;
			_properties = null;
			_eventHandlers = null;
			_postConstruct = null;
			_preDestroy = null;
			_friends = null;
		}
		
		public function clone():Recipe
		{
			const clone:Recipe = new Recipe;
			if (hasConstructorArguments) clone._constructorArguments = constructorArguments.concat();
			if (hasProperties) clone._properties = ObjectUtil.clone(properties);
			if (hasEventHandlers) clone._eventHandlers = eventHandlers.concat();
			if (hasFriends) clone._friends = friends.concat();
			clone._postConstruct = postConstruct;
			clone._preDestroy = preDestroy;
			return clone;
		}
		
		public function empty():Recipe
		{
			if (hasConstructorArguments) _constructorArguments.length = 0;
			if (hasEventHandlers) _eventHandlers.length = 0;
			if (hasProperties) ObjectUtil.empty(_properties);
			if (hasFriends) _friends.length = 0;
			_postConstruct = null;
			_preDestroy = null;
			return this;
		}
		
		public function extend(recipe:Recipe):Recipe
		{
			if (recipe.hasConstructorArguments) for (var i:int = 0; i < recipe.constructorArguments.length; i++) constructorArguments[i] = recipe.constructorArguments[i]; // expensive with LinkedList
			if (recipe.hasProperties) ObjectUtil.extend(properties, recipe.properties);
			if (recipe.hasEventHandlers) for each(var eventHandler:IEventHandler in recipe.eventHandlers) eventHandlers[eventHandlers.length] = eventHandler;
			if (recipe.hasComposer) postConstruct = recipe.postConstruct;
			if (recipe.hasDisposer) preDestroy = recipe.preDestroy;
			if (recipe.hasFriends)
			{
				for each(var filter:IFilter in recipe.friends)
				{
					if ((i = friends.indexOf(recipe)) < 0) friends[friends.length] = filter;
				}
			}
			return this;
		}
		
		public function get hasConstructorArguments():Boolean 
		{
			return _constructorArguments != null && _constructorArguments.length;
		}
		
		public function get hasProperties():Boolean 
		{
			return ObjectUtil.isEmpty(_properties);
		}
		
		public function get hasComposer():Boolean 
		{
			return _postConstruct != null && _postConstruct.length;
		}
		
		public function get hasDisposer():Boolean 
		{
			return _preDestroy != null && _preDestroy.length;
		}
		
		public function get hasEventHandlers():Boolean 
		{
			return _eventHandlers != null && _eventHandlers.length;
		}
		
		public function get hasFriends():Boolean
		{
			return _friends != null && _friends.length;
		}
		
		public function get constructorArguments():Array 
		{
			return _constructorArguments ||= [];
		}
		
		public function set constructorArguments(value:Array):void 
		{
			_constructorArguments = value;
		}
		
		public function get properties():Object 
		{
			return _properties ||= {};
		}
		
		public function set properties(value:Object):void 
		{
			_properties = value;
		}
		
		public function get eventHandlers():Array
		{
			return _eventHandlers ||= [];
		}
		
		public function set eventHandlers(value:Array):void 
		{
			_eventHandlers = value;
		}
		
		public function get postConstruct():String 
		{
			return _postConstruct;
		}
		
		public function set postConstruct(value:String):void 
		{
			_postConstruct = value;
		}
		
		public function get preDestroy():String 
		{
			return _preDestroy;
		}
		
		public function set preDestroy(value:String):void 
		{
			_preDestroy = value;
		}
		
		public function get friends():Array
		{
			return _friends ||= [];
		}
		
		public function set friends(value:Array):void
		{
			_friends = value;
		}
		
	}

}
