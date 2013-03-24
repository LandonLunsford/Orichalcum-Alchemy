package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.provider.ReferenceProvider;

	/**
	 * Convenience method for "new ReferenceProvider()"
	 * @param	reference The string ID of any mapped provision
	 * @return	new ReferenceProvider
	 */
	public function reference(reference:String):IProvider
	{
		return new ReferenceProvider(reference);
	}

}