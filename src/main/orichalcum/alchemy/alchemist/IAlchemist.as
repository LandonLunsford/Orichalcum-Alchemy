package orichalcum.alchemy.alchemist 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.mapper.IMapper;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.recipe.Recipe;
	
	public interface IAlchemist extends IEvaluator
	{
		// crux
		function conjure(id:*, recipe:Recipe = null):*;
		
		// map provider
		function map(id:*):IMapper;
		//function provides(id:*):Boolean; //not exposed
		//function providesDirectly(id:*):Boolean; //not exposed
		
		// map recipe
		//function cook(id:*):IMapper;
		//function cooks(id:*):Boolean; //not exposed
		//function cooksDirectly(id:*):Boolean; //not exposed
		
		// map mediator (PHASE 2)
		//function mediate(id:*):IMediatorMapping; //not exposed yet
		//function mediates(id:*):Boolean; //not exposed
		//function mediatesDirectly(id:*):Boolean; //not exposed
		
		// lifecycle
		function create(type:Class, recipe:Recipe = null):Object;
		function inject(instance:Object):Object;
		function destroy(instance:Object):Object;
		//function bind(instance:Object):Object	//not exposed
		//function compose(instance:Object):Object //not exposed
		//function unbind(instance:Object):Object //not exposed
		//function unject(instance:Object):Object //not exposed yet
		
		// modularity
		function extend():IAlchemist;
		
		// configuration
		function get metatagBundle():IMetatagBundle;
		function set metatagBundle(value:IMetatagBundle):void;
		function get expressionQualifier():RegExp;
		function set expressionQualifier(value:RegExp):void;
		function get expressionRemovals():RegExp;
		function set expressionRemovals(value:RegExp):void;
		
		// utility
		//function createRecipe(classOrInstance:*):Recipe //not exposed -- creation will occur through IMapper
	}

}
