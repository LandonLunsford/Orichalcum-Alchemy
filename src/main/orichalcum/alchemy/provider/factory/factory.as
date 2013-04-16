package orichalcum.alchemy.provider.factory
{
	import orichalcum.alchemy.provider.FactoryProvider;
	import orichalcum.alchemy.provider.IProvider;

	/**
	 * Convenience method for "new FactoryProvider()"
	 * @param	factoryMethod The factory method (e.g. function():* or function(activeAlchemist:IAlchemist):*)
	 * @return	new FactoryProvider
	 */
	public function factory(factoryMethod:Function):IProvider
	{
		return new FactoryProvider(factoryMethod);
	}

}
