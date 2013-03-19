package orichalcum.alchemy.mapper 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.binding.Binding;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.utility.StringUtil;

	public class Mapper implements IMapper
	{
		private var _id:String;
		private var _providers:Dictionary;
		private var _recipes:Dictionary;
		private var _recipe:Recipe;
		private var _constructorArgumentIndex:int;
		
		public function Mapper(id:String, providers:Dictionary, recipes:Dictionary) 
		{
			_id = id;
			_providers = providers;
			_recipes = recipes;
		}
		
		/* INTERFACE orichalcum.alchemy.mapper.IMapper */
		
		public function to(providerValueOrReference:*):IMapper
		{
			_providers[_id] && onProviderOverwrite(_id);
			_providers[_id] = providerValueOrReference;
			return this;
		}
		
		public function withConstructorArguments(...args):IMapper 
		{
			for (var i:int = 0; i < args.length; i++)
				withConstructorArgument(args[i], i);
			return this;
		}
		
		public function withConstructorArgument(value:*, index:int = -1):IMapper 
		{
			if (index < 0 || index >= _constructorArgumentIndex)
				index = _constructorArgumentIndex++;
				
			recipe.constructorArguments[index] = value;
			return this;
		}
		
		public function withProperties(properties:Object):IMapper 
		{
			for (var propertyName:String in properties)
				withProperty(propertyName, properties[propertyName]);
			return this;
		}
		
		public function withProperty(name:String, value:*):IMapper 
		{
			recipe.properties[name] = value;
			return this;
		}
		
		public function withComposer(value:String):IMapper 
		{
			recipe.composer = value;
			return this;
		}
		
		public function withDisposer(value:String):IMapper 
		{
			recipe.disposer = value;
			return this;
		}
		
		public function withBinding(type:String, listener:String, target:String = null, useCapture:Boolean = false, priority:uint = 0, stopPropagation:Boolean = false, stopImmediatePropagation:Boolean = false):IMapper 
		{
			recipe.bindings.push(new Binding(type, listener, target, priority, useCapture, stopPropagation, stopImmediatePropagation));
			return this;
		}
		
		/* PRIVATE PARTS */
		
		private function get recipe():Recipe
		{
			if (_recipe) return _recipe;
			_recipes[_id] && onRecipeOverwrite(_id);
			return _recipes[_id] = _recipe = new Recipe;
		}
		
		private function onProviderOverwrite(id:String):void
		{
			throwWarning('[WARNING] Provider for "{0}" has been overwritten.', id);
		}
		
		private function onRecipeOverwrite(id:String):void
		{
			throwWarning('[WARNING] Recipe for "{0}" has been overwritten.', id);
		}
		
		private function throwWarning(message:String, ...substitutions):void
		{
			// could use central event dispatcher provided by the alchemist
			// for now I am contempt with just tracing the information
			// additional strict mode could listen for this and throw an error
			trace(StringUtil.substitute(message, substitutions));
		}
		
	}

}
