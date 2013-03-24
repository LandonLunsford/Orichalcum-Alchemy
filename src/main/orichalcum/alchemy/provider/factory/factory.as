package orichalcum.alchemy.provider.factory 
{
	import orichalcum.alchemy.provider.FactoryProvider;
	import orichalcum.alchemy.provider.IProvider;

	/**
	 * Convenience method for "new FactoryProvider()"
	 * @param	factory The factory method (e.g. function():* or function(activeAlchemist:IAlchemist):*)
	 * @return	new FactoryProvider
	 */
	public function factory(factory:Function):IProvider
	{
		return new FactoryProvider(factory);
	}

}