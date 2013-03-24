package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.ValueProvider;

	/**
	 * Convenience method for "new ValueProvider()"
	 * @param	value The value the provider will provide
	 * @return	new ValueProvider
	 */
	public function value(value:*):IProvider
	{
		return new ValueProvider(value);
	}

}