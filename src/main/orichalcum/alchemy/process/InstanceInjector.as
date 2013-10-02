package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class InstanceInjector implements IAlchemyProcess
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):* 
		{
			for (var propertyName:String in recipe.properties)
			{
				instance[propertyName] = evaluator.evaluate(recipe.properties[propertyName]);
			}
			return instance;
		}
		
	}

}