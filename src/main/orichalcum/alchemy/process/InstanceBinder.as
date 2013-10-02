package orichalcum.alchemy.process 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.handler.IEventHandler;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.utility.ObjectUtil;


	public class InstanceBinder implements IAlchemyProcess 
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			for each(var eventHandler:IEventHandler in recipe.eventHandlers)
			{
				var target:Object = ObjectUtil.find(instance, eventHandler.targetPath);
				var eventDispatcher:IEventDispatcher = target as IEventDispatcher;
				
				if (eventDispatcher == null)
				{
					if (target === instance)
					{
						throw new AlchemyError('Class "{0}" must implement "flash.events::IEventDispatcher" in order to have an event handler with no target specified.', getQualifiedClassName(instance));
					}
					else
					{
						throw new AlchemyError('Variable or child named "{0}" could not be found on "{1}". Check to make sure that it is public and/or named correctly.', eventHandler.targetPath, instance);
					}
				}
					
				if (!(eventHandler.listenerName in instance))
					throw new AlchemyError('Unable to bind method "{0}" to event type "{1}". Method "{0}" not found on "{2}".', eventHandler.listenerName, eventHandler.type, getQualifiedClassName(instance));
				
				eventHandler.listener = instance[eventHandler.listenerName];
				eventDispatcher.addEventListener(eventHandler.type, eventHandler.handle, eventHandler.useCapture, eventHandler.priority);
			}
			return instance;
		}
		
	}

}