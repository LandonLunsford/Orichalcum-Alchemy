package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.ForwardingProvider;
	import orichalcum.alchemy.provider.IProvider;

	public function provider(providerType:Class):IProvider
	{
		return new ForwardingProvider(providerType);
	}

}