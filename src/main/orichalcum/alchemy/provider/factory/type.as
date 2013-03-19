package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.PrototypeProvider;

	public function type(type:Class):IProvider
	{
		return new PrototypeProvider(type);
	}

}