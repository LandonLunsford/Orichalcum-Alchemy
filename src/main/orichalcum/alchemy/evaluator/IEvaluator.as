package orichalcum.alchemy.evaluator 
{
	
	public interface IEvaluator 
	{
		/**
		 * Parses the value of the argument depending on whether it is an IProvider, reference or value
		 * @param	providerReferenceOrValue
		 * @return	provider.provide() if the argument is IProvider,
		 * 		alchemist.conjure(reference) if the argument is a reference
		 * 		argument if the value is none of the above.
		 */
		function evaluate(providerReferenceOrValue:*):*;
	}

}