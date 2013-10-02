package orichalcum.alchemy.process 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;
	
	
	public interface IAlchemyProcess
	{
		
		function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):*
		
	}

}