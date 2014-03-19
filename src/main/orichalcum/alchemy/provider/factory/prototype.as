package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.PrototypeProvider;

	/**
	 * Convenience method for "new PrototypeProvider()"
	 * @param	type The class of the prototype
	 * @return	new PrototypeProvider
	 */
	public function prototype(type:Class):IProvider
	{
		return new PrototypeProvider(type);
	}

}