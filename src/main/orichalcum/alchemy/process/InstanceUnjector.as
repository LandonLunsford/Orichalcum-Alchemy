package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class InstanceUnjector implements IAlchemyProcess
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):* 
		{
			for (var propertyName:String in recipe.properties)
			{
				if (instance[propertyName] is Object)
				{
					instance[propertyName] = null;
				}
			}
			return instance;
		}
		
	}

}