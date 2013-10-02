package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class InstanceComposer implements IAlchemyProcess
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):* 
		{
			recipe.hasComposer && (instance[recipe.postConstruct] as Function).call(instance);
			return instance;
		}
		
	}

}