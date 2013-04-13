package orichalcum.alchemy.mapper 
{
	import orichalcum.alchemy.alchemist.IAlchemist;

	public class AlchemistMapper 
	{
		
		public function map(alchemist:IAlchemist, mappings:XML):IAlchemist
		{
			if (alchemist == null)
				throw new ArgumentError;
				
			if (mappings == null)
				throw new ArgumentError;
			
			return _map(alchemist, mappings);
		}
		
		private function _map(alchemist:IAlchemist, mappings:XML):IAlchemist 
		{
			/**
			 * TODO
			 */
			
			return alchemist;
		}
		
	}

}