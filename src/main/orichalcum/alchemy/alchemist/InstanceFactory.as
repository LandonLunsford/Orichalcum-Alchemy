package orichalcum.alchemy.alchemist 
{
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.handler.IEventHandler;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.utility.ObjectUtil;
	import orichalcum.utility.StringUtil;

	/**
	 * This class performs the dirty work of the alchemist
	 * It is the alchemists' instance creator, injector, binder,
	 * composer, disposer, unbinder and injector
	 * @private
	 */
	internal class InstanceFactory
	{
		
		public function create(type:Class, recipe:Recipe, evaluator:IEvaluator):Object 
		{
			return compose(inject(createInstance(type, recipe, evaluator), recipe, evaluator), recipe);
		}
		
		public function inject(instance:Object, recipe:Recipe, evaluator:IEvaluator):Object 
		{
			for (var propertyName:String in recipe.properties)
				instance[propertyName] = evaluator.evaluate(recipe.properties[propertyName]);
			return bind(instance, recipe);
		}
		
		private function compose(instance:Object, recipe:Recipe):Object
		{
			recipe.hasComposer && (instance[recipe.postConstruct] as Function).call(instance);
			return instance;
		}
		
		public function destroy(instance:Object, recipe:Recipe):Object 
		{
			recipe.hasDisposer && (instance[recipe.preDestroy] as Function).call(instance);
			return unject(unbind(instance, recipe), recipe);
		}
		
		private function bind(instance:Object, recipe:Recipe):Object
		{
			if (!recipe.hasEventHandlers)
				return instance;
			
			for each(var eventHandler:IEventHandler in recipe.eventHandlers)
			{
				var target:IEventDispatcher = ObjectUtil.find(instance, eventHandler.targetPath) as IEventDispatcher;
				
				if (!target)
					throw new AlchemyError('Variable or child named "{0}" could not be found on "{1}". Check to make sure that it is public and/or named correctly.', eventHandler.targetPath, instance);
					
				if (!(eventHandler.listenerName in instance))
					throw new AlchemyError('Unable to bind method "{0}" to event type "{1}". Method "{0}" not found on "{2}".', eventHandler.listenerName, eventHandler.type, getQualifiedClassName(instance));
				
				eventHandler.listener = instance[eventHandler.listenerName];
				target.addEventListener(eventHandler.type, eventHandler.handle, eventHandler.useCapture, eventHandler.priority);
			}
			return instance;
		}
		
		private function unbind(instance:Object, recipe:Recipe):Object
		{
			if (!recipe.hasEventHandlers)
				return instance;
			
			for each(var eventHandler:IEventHandler in recipe.eventHandlers)
			{
				var target:IEventDispatcher = ObjectUtil.find(instance, eventHandler.targetPath) as IEventDispatcher;
					
				if (target.hasEventListener(eventHandler.type))
					target.removeEventListener(eventHandler.type, eventHandler.handle);
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
		
		private function createInstance(type:Class, recipe:Recipe, evaluator:IEvaluator):Object
		{
			if (type == null)
				throw new ArgumentError('Argument "type" passed to method "createInstance" must not be null.');
			
			if (recipe.hasConstructorArguments)
			{
				const a:Array = recipe.constructorArguments;
				switch(a.length)
				{
					case 1:	return new type(
						evaluator.evaluate(a[0]));
						
					case 2: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]));
						
					case 3: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]));
						
					case 4: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]));
						
					case 5: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]));
						
					case 6: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]));
						
					case 7: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]));
						
					case 8: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]));
						
					case 9:	return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]));
						
					case 10: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]));
						
					case 11: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]));
						
					case 12: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]),
						evaluator.evaluate(a[11]));
						
					case 13: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]),
						evaluator.evaluate(a[11]),
						evaluator.evaluate(a[12]));
						
					case 14: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]),
						evaluator.evaluate(a[11]),
						evaluator.evaluate(a[12]),
						evaluator.evaluate(a[13]));
						
					case 15: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]),
						evaluator.evaluate(a[11]),
						evaluator.evaluate(a[12]),
						evaluator.evaluate(a[13]),
						evaluator.evaluate(a[14]));
						
					case 16: return new type(
						evaluator.evaluate(a[0]),
						evaluator.evaluate(a[1]),
						evaluator.evaluate(a[2]),
						evaluator.evaluate(a[3]),
						evaluator.evaluate(a[4]),
						evaluator.evaluate(a[5]),
						evaluator.evaluate(a[6]),
						evaluator.evaluate(a[7]),
						evaluator.evaluate(a[8]),
						evaluator.evaluate(a[9]),
						evaluator.evaluate(a[10]),
						evaluator.evaluate(a[11]),
						evaluator.evaluate(a[12]),
						evaluator.evaluate(a[13]),
						evaluator.evaluate(a[14]),
						evaluator.evaluate(a[15]));
				}
				throw new ArgumentError(StringUtil.substitute('Type "{0}" requires over {1} constructor arguments. Consider refactoring.', getQualifiedClassName(type), 16));
			}
			return new type;
		}
		
	}

}
