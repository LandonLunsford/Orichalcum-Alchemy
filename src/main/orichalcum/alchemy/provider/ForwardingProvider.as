package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class ForwardingProvider implements IProvider
	{
		private var _providerId:*;
		private var _provider:IProvider;
		
		/**
		 * @param providerId The custom ID, Class or qualifiedClassName of the custom provider
		 */
		public function ForwardingProvider(providerId:*) 
		{
			_providerId = providerId;
			_provider = null;
		}
		
		public function provide(id:*, alchemist:IAlchemist, recipe:Dictionary):* 
		{
			_provider = alchemist.conjure(_providerId, recipe);
			return _provider.provide(id, alchemist, recipe);
		}
		
		public function destroy(provision:*):* 
		{
			return _provider.destroy(provision);
		}
		
	}

}
