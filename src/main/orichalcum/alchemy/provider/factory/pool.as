package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.PooledInstanceProvider;
	
	public function pool(type:Class):IProvider 
	{
		return new PooledInstanceProvider(type);
	}

}