package orichalcum.alchemy.process 
{
	import flash.events.IEventDispatcher;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.handler.IEventHandler;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.utility.ObjectUtil;


	public class InstanceUnbinder implements IAlchemyProcess
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):* 
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
		
	}

}