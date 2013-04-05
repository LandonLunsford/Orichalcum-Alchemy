package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.ReferenceProvider;
	
	/**
	 * Convenience method for "new ReferenceProvider()"
	 * @param	id Custom name, class or qualified class name	
	 * @return	new ReferenceProvider
	 */
	public function reference(id:*):IProvider
	{
		return new ReferenceProvider(id);
	}

}