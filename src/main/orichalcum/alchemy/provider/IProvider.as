package orichalcum.alchemy.provider 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;

	public interface IProvider 
	{
		/**
		 * Provides the provision this provider is responsible for providing
		 * @param	activeAlchemist The alchemist managing this provider
		 * @param	activeRecipe The recipe mapped to the provision
		 * @return	The provision it is responsible for providing.
		 */
		function provide(id:*, activeAlchemist:IAlchemist, activeRecipe:Dictionary):*;
		
		/**
		 * Destruction phase hook
		 * @param	provision The provision this Provider provided.
		 * @return	The provision
		 * @see #provide
		 */
		function destroy(provision:*):*;
	}

}
