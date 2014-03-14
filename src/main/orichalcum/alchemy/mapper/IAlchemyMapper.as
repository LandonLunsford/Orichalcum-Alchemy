package orichalcum.alchemy.mapper
{
	import org.flexunit.runner.manipulation.IFilter;
	
	public interface IAlchemyMapper
	{
		/**
		 * Sets the provider to either a value, reference or provider
		 * @param	providerValueOrReference Any value, reference or provider
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.provider.IProvider
		 */
		function to(providerValueOrReference:*):IAlchemyMapper;
		
		function add(...ingredients):IAlchemyMapper;
		
	}

}
