package orichalcum.alchemy.recipe 
{
	import orichalcum.alchemy.provider.factory.value;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.utility.ObjectUtil;

	/**
	 * Recipe can be furthur decomposed into
	 * 1. constructor ingredients
	 * 2. property ingredients
	 * 3. lifecycle ingredients
	 * 4. event handler ingredients
<<<<<<< HEAD
	 * If I lazily create these recipe components separatly I could
	 * save runtime evaluation complexity for users who do not utilize these functions
=======
	 * If I lazily create these recipe components separatly I could potentially
	 * save runtime evaluation complexity for users who do not utilize these features
>>>>>>> added dispose() impl
	 */
	public class Recipe implements IDisposable
	{
		private var _constructorArguments:Array;
		private var _properties:Object;
		private var _bindings:Array;
		private var _composer:String;
		private var _disposer:String;
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			for each(var disposable:IDisposable in _constructorArguments)
				disposable && disposable.dispose();
			
			for each(disposable in _bindings)
				disposable && disposable.dispose();
				
			for (var disposableName:String in _properties)
				_properties[disposableName] is IDisposable && (_properties[disposableName] as IDisposable).dispose();
			_constructorArguments = null;
			_properties = null;
			_bindings = null;
			_composer = null;
			_disposer = null;
		}
		
		public function clone():Recipe
		{
			const clone:Recipe = new Recipe;
			if (hasConstructorArguments) clone._constructorArguments = constructorArguments.concat();
			if (hasProperties) clone._properties = ObjectUtil.clone(properties);
			if (hasBindings) clone._bindings = bindings.concat();
			clone._composer = composer;
			clone._disposer = disposer;
			return clone;
		}
		
		public function empty():Recipe
		{
			if (hasConstructorArguments) _constructorArguments.length = 0;
			if (hasBindings) _bindings.length = 0;
			if (hasProperties) ObjectUtil.empty(_properties);
			_composer = null;
			_disposer = null;
			return this;
		}
		
		public function extend(recipe:Recipe):Recipe
		{
			if (recipe.hasConstructorArguments) for (var i:int = 0; i < recipe.constructorArguments.length; i++) constructorArguments[i] = recipe.constructorArguments[i];
			if (recipe.hasProperties) ObjectUtil.extend(properties, recipe.properties);
			if (recipe.hasBindings) bindings.push.apply(null, recipe.bindings);
			if (recipe.hasComposer) composer = recipe.composer;
			if (recipe.hasDisposer) disposer = recipe.disposer;
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
			return _composer != null && _composer.length;
		}
		
		public function get hasDisposer():Boolean 
		{
			return _disposer != null && _disposer.length;
		}
		
		public function get hasBindings():Boolean 
		{
			return _bindings != null && _bindings.length;
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
		
		public function get bindings():Array
		{
			return _bindings ||= [];
		}
		
		public function set bindings(value:Array):void 
		{
			_bindings = value;
		}
		
		public function get composer():String 
		{
			return _composer;
		}
		
		public function set composer(value:String):void 
		{
			_composer = value;
		}
		
		public function get disposer():String 
		{
			return _disposer;
		}

		public function set disposer(value:String):void 
		{
			_disposer = value;
		}
		
	}

}
