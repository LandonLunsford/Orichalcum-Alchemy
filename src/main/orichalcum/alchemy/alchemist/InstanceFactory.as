package orichalcum.alchemy.alchemist 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.utility.StringUtil;

	
	public class InstanceFactory 
	{
		
		public function create(type:Class, alchemist:IEvaluator, ingredients:Dictionary):*
		{
			if (type == null)
				throw new ArgumentError('Argument "type" passed to method "createInstance" must not be null.');
			
			// need to delegate to process...
			
			const constructorArguments:Array = ingredients['constructorArguments'];
			
			//trace('InstanceFactory.create()', type, alchemist, ingredients, ingredients.constructorArguments);
				
			if (constructorArguments && constructorArguments.length)
			{
				switch(constructorArguments.length)
				{
					case 1:	return new type(
						alchemist.evaluate(constructorArguments[0]));
						
					case 2: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]));
						
					case 3: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]));
						
					case 4: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]));
						
					case 5: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]));
						
					case 6: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]));
						
					case 7: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]));
						
					case 8: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]));
						
					case 9:	return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]));
						
					case 10: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]));
						
					case 11: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]));
						
					case 12: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]),
						alchemist.evaluate(constructorArguments[11]));
						
					case 13: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]),
						alchemist.evaluate(constructorArguments[11]),
						alchemist.evaluate(constructorArguments[12]));
						
					case 14: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]),
						alchemist.evaluate(constructorArguments[11]),
						alchemist.evaluate(constructorArguments[12]),
						alchemist.evaluate(constructorArguments[13]));
						
					case 15: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]),
						alchemist.evaluate(constructorArguments[11]),
						alchemist.evaluate(constructorArguments[12]),
						alchemist.evaluate(constructorArguments[13]),
						alchemist.evaluate(constructorArguments[14]));
						
					case 16: return new type(
						alchemist.evaluate(constructorArguments[0]),
						alchemist.evaluate(constructorArguments[1]),
						alchemist.evaluate(constructorArguments[2]),
						alchemist.evaluate(constructorArguments[3]),
						alchemist.evaluate(constructorArguments[4]),
						alchemist.evaluate(constructorArguments[5]),
						alchemist.evaluate(constructorArguments[6]),
						alchemist.evaluate(constructorArguments[7]),
						alchemist.evaluate(constructorArguments[8]),
						alchemist.evaluate(constructorArguments[9]),
						alchemist.evaluate(constructorArguments[10]),
						alchemist.evaluate(constructorArguments[11]),
						alchemist.evaluate(constructorArguments[12]),
						alchemist.evaluate(constructorArguments[13]),
						alchemist.evaluate(constructorArguments[14]),
						alchemist.evaluate(constructorArguments[15]));
				}
				throw new ArgumentError(StringUtil.substitute('Type "{0}" requires over {1} constructor arguments. Consider refactoring.', getQualifiedClassName(type), 16));
			}
			return new type;
		}
		
	}

}