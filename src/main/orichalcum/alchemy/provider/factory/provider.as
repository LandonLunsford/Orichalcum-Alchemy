package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.ForwardingProvider;
	import orichalcum.alchemy.provider.IProvider;

	/**
	 * Convenience method for "new ForwardingProvider()"
	 * @param	providerType The class of the custom provider
	 * @return	new ForwardingProvider
	 */
	public function provider(providerType:Class):IProvider
	{
		return new ForwardingProvider(providerType);
	}

}