package orichalcum.alchemy.filter 
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.recipe.Recipe;
	
	public interface IFilter 
	{
		function applies(provision:*, context:IAlchemist):Boolean;
		function onProvide(provision:*, context:IAlchemist):void;
		function onDestroy(provision:*, context:IAlchemist):void;
	}

}