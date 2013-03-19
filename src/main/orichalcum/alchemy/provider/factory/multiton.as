package orichalcum.alchemy.provider.factory
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.MultitonProvider;
	
	public function multiton(type:Class, poolSize:uint = 0):IProvider
	{
		return new MultitonProvider(type, poolSize);
	}

}