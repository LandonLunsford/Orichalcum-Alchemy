package orichalcum.alchemy.alchemist 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.evaluator.IEvaluator;

	
	public class InstanceFactory 
	{
		
		function create(type:Class, evaluator:IEvaluator, ingredients:Dictionary):void
		{
			if (type == null)
				throw new ArgumentError('Argument "type" passed to method "createInstance" must not be null.');
			
			const constructorArguments:Array = ingredients.constructorArguments;
				
			if (constructorArguments && constructorArguments.length)
			{
				switch(constructorArguments.length)
				{
					case 1:	return new type(
						_evaluator.evaluate(constructorArguments[0]));
						
					case 2: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]));
						
					case 3: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]));
						
					case 4: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]));
						
					case 5: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]));
						
					case 6: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]));
						
					case 7: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]));
						
					case 8: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]));
						
					case 9:	return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]));
						
					case 10: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]));
						
					case 11: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]));
						
					case 12: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]),
						_evaluator.evaluate(constructorArguments[11]));
						
					case 13: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]),
						_evaluator.evaluate(constructorArguments[11]),
						_evaluator.evaluate(constructorArguments[12]));
						
					case 14: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]),
						_evaluator.evaluate(constructorArguments[11]),
						_evaluator.evaluate(constructorArguments[12]),
						_evaluator.evaluate(constructorArguments[13]));
						
					case 15: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]),
						_evaluator.evaluate(constructorArguments[11]),
						_evaluator.evaluate(constructorArguments[12]),
						_evaluator.evaluate(constructorArguments[13]),
						_evaluator.evaluate(constructorArguments[14]));
						
					case 16: return new type(
						_evaluator.evaluate(constructorArguments[0]),
						_evaluator.evaluate(constructorArguments[1]),
						_evaluator.evaluate(constructorArguments[2]),
						_evaluator.evaluate(constructorArguments[3]),
						_evaluator.evaluate(constructorArguments[4]),
						_evaluator.evaluate(constructorArguments[5]),
						_evaluator.evaluate(constructorArguments[6]),
						_evaluator.evaluate(constructorArguments[7]),
						_evaluator.evaluate(constructorArguments[8]),
						_evaluator.evaluate(constructorArguments[9]),
						_evaluator.evaluate(constructorArguments[10]),
						_evaluator.evaluate(constructorArguments[11]),
						_evaluator.evaluate(constructorArguments[12]),
						_evaluator.evaluate(constructorArguments[13]),
						_evaluator.evaluate(constructorArguments[14]),
						_evaluator.evaluate(constructorArguments[15]));
				}
				throw new ArgumentError(StringUtil.substitute('Type "{0}" requires over {1} constructor arguments. Consider refactoring.', getQualifiedClassName(type), 16));
			}
			return new type;
		}
		
	}

}