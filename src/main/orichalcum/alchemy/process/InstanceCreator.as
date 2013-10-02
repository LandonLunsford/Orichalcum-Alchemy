package orichalcum.alchemy.process 
{
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.utility.StringUtil;


	public class InstanceCreator implements IAlchemyProcess
	{
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe, evaluator:IEvaluator):* 
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