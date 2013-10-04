package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class InstanceDestroyer implements IAlchemyProcess
	{
		
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			//recipe.hasDisposer && (instance[recipe.preDestroy] as Function).call(instance, recipe);
			recipe.hasDisposer && (instance[recipe.preDestroy] as Function).call(instance);
			return instance;
		}
		
	}

}