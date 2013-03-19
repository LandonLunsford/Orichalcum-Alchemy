package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.ValueProvider;

	public function value(value:*):IProvider
	{
		return new ValueProvider(value);
	}

}