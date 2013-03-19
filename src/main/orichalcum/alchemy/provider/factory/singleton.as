package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.SingletonProvider;

	public function singleton(type:Class):IProvider
	{
		return new SingletonProvider(type);
	}

}