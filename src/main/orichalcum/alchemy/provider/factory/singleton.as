package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.SingletonProvider;

	/**
	 * Convenience method for "new SingletonProvider()"
	 * @param	type The class of the singleton
	 * @return	new SingletonProvider
	 */
	public function singleton(type:Class):IProvider
	{
		return new SingletonProvider(type);
	}

}