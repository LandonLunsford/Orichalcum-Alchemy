package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class InstanceInjector implements IAlchemyProcess
	{
		
		private var _evaluator:IEvaluator;
		
		public function InstanceInjector(evaluator:IEvaluator):void
		{
			_evaluator = evaluator;
		}
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			for (var propertyName:String in recipe.properties)
			{
				instance[propertyName] = _evaluator.evaluate(recipe.properties[propertyName]);
			}
			return instance;
		}
		
	}

}