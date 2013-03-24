package orichalcum.alchemy.provider.factory
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.MultitonProvider;
	
	/**
	 * Convenience method for "new MultitonProvider()"
	 * @param	type The class of the multiton
	 * @param	poolSize The maximum number of instances allowed
	 * @return	new MultitonProvider
	 */
	public function multiton(type:Class, poolSize:uint = 0):IProvider
	{
		return new MultitonProvider(type, poolSize);
	}

}