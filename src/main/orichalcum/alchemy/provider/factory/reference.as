package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.ReferenceProvider;

	public function reference(reference:String):IProvider
	{
		return new ReferenceProvider(reference);
	}

}