package orichalcum.alchemy.alchemist 
{
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.binding.IBinding;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.utility.ObjectUtil;
	import orichalcum.utility.StringUtil;

	/**
	 * This class performs the dirty work of the alchemist
	 * It is the alchemists' instance creator, injector, binder,
	 * composer, disposer, unbinder and injector
	 * 
	 * Requires Alchemist.conjure
	 * Requires ExpressionEvaluator.evaluate
	 */
	internal class InstanceFactory implements IDisposable
	{
		private var _evaluator:IEvaluator;
		
		public function InstanceFactory(evaluator:IEvaluator) 
		{
			_evaluator = evaluator;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			_evaluator = null;
		}
		
		public function create(type:Class, recipe:Recipe):Object 
		{
			return compose(inject(createInstance(type, recipe), recipe), recipe);
		}
		
		public function inject(instance:Object, recipe:Recipe):Object 
		{
			for (var propertyName:String in recipe.properties)
				instance[propertyName] = _evaluator.evaluate(recipe.properties[propertyName]);
			return bind(instance, recipe);
		}
		
		private function compose(instance:Object, recipe:Recipe):Object
		{
			recipe.hasComposer && (instance[recipe.composer] as Function).call(instance);
			return instance;
		}
		
		public function destroy(instance:Object, recipe:Recipe):Object 
		{
			recipe.hasDisposer && (instance[recipe.disposer] as Function).call(instance);
			return unject(unbind(instance, recipe), recipe);
		}
		
		private function bind(instance:Object, recipe:Recipe):Object
		{
			if (!recipe.hasBindings)
				return instance;
			
			for each(var binding:IBinding in recipe.bindings)
			{
				var target:IEventDispatcher = ObjectUtil.find(instance, binding.targetPath) as IEventDispatcher;
				
				if (!(binding.listenerName in instance))
					throw new AlchemyError('Unable to bind "{0}" to "{1}". Method named "{0}" not found on "{2}"', binding.listenerName, binding.type, getQualifiedClassName(instance));
				
				binding.listener = instance[binding.listenerName];
				target.addEventListener(binding.type, binding.handle, binding.useCapture, binding.priority);
			}
			return instance;
		}
		
		private function unbind(instance:Object, recipe:Recipe):Object
		{
			if (!recipe.hasBindings)
				return instance;
			
			for each(var binding:IBinding in recipe.bindings)
			{
				var target:IEventDispatcher = ObjectUtil.find(instance, binding.targetPath) as IEventDispatcher;
				if (target.hasEventListener(binding.type))
					target.removeEventListener(binding.type, binding.handle);
			}
			return instance;
		}
		
		private function unject(instance:Object, recipe:Recipe):Object
		{
			for (var propertyName:String in recipe.properties)
				if (instance[propertyName] is Object)
					instance[propertyName] = null;
			return instance;
		}
		
		private function createInstance(type:Class, recipe:Recipe):Object
		{
			if (type == null)
				throw new ArgumentError('Argument "type" passed to method "createInstance" must not be null.');
			
			if (recipe.hasConstructorArguments)
			{
				const a:Array = recipe.constructorArguments;
				switch(a.length)
				{
					case 1:	return new type(
						_evaluator.evaluate(a[0]));
						
					case 2: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]));
						
					case 3: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]));
						
					case 4: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]));
						
					case 5: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]));
						
					case 6: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]));
						
					case 7: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]));
						
					case 8: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]));
						
					case 9:	return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]));
						
					case 10: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]));
						
					case 11: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]));
						
					case 12: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]),
						_evaluator.evaluate(a[11]));
						
					case 13: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]),
						_evaluator.evaluate(a[11]),
						_evaluator.evaluate(a[12]));
						
					case 14: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]),
						_evaluator.evaluate(a[11]),
						_evaluator.evaluate(a[12]),
						_evaluator.evaluate(a[13]));
						
					case 15: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]),
						_evaluator.evaluate(a[11]),
						_evaluator.evaluate(a[12]),
						_evaluator.evaluate(a[13]),
						_evaluator.evaluate(a[14]));
						
					case 16: return new type(
						_evaluator.evaluate(a[0]),
						_evaluator.evaluate(a[1]),
						_evaluator.evaluate(a[2]),
						_evaluator.evaluate(a[3]),
						_evaluator.evaluate(a[4]),
						_evaluator.evaluate(a[5]),
						_evaluator.evaluate(a[6]),
						_evaluator.evaluate(a[7]),
						_evaluator.evaluate(a[8]),
						_evaluator.evaluate(a[9]),
						_evaluator.evaluate(a[10]),
						_evaluator.evaluate(a[11]),
						_evaluator.evaluate(a[12]),
						_evaluator.evaluate(a[13]),
						_evaluator.evaluate(a[14]),
						_evaluator.evaluate(a[15]));
				}
				throw new ArgumentError(StringUtil.substitute('Type "{0}" requires over {1} constructor arguments. Consider refactoring.', getQualifiedClassName(type), 16));
			}
			return new type;
		}
		
	}

}
