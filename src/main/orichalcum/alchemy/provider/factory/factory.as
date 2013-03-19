package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.FactoryProvider;
	import orichalcum.alchemy.provider.IProvider;

	public function factory(factory:Function):IProvider
	{
		return new FactoryProvider(factory);
	}

}