package orichalcum.alchemy.alchemist 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.recipe.Recipe;
	
	public interface IAlchemist extends IEvaluator
	{
		
		/**
		 * Maps the ID specified to a provider, recipe or mediator.
		 * @param	id Custom name, class or qualified class name
		 * @return	Provider, recipe and mediator mapper
		 * @see		orichalcum.alchemy.mapper.IAlchemyMapper
		 */
		function map(id:*):IAlchemyMapper;
		
		/**
		 * Gets or creates an injected object of the type mapped to the ID
		 * based on the provider and recipe mapped to the specified ID.
		 * @param	id Custom name, class or qualified class name
		 * @param	recipe Custom recipe used to override the mapped recipe
		 * @return	An instance of the object type mapped to the ID
		 */
		function conjure(id:*, recipe:Recipe = null):*;
		
		/**
		 * Creates, injects, calls post-construct hook and returns an object mapped to the ID
		 * based on the provider and recipe mapped to the specified ID.
		 * @param	id Custom name, class or qualified class name
		 * @param	recipe Custom recipe used to override the mapped recipe
		 * @return	An instance of the object type mapped to the id
		 */
		function create(type:Class, recipe:Recipe = null):Object;
		
		/**
		 * Injects and binds an object based on the object's class metatags and class-mapped recipes
		 * @param	instance The object to inject and bind event handlers to
		 * @return	the instance passed as an argument
		 */
		function inject(instance:Object):Object;
		
		/**
		 * Unbinds, calls pre-destroy hook and returns the instance
		 * @param	instance The object to inject and bind event handlers to
		 * @return	the instance passed as an argument
		 */
		function destroy(instance:Object):Object;
		
		/**
		 * Creates a child alchemist which will fallback on its parent's mappings
		 * when it cannot an injection request.
		 * @return child alchemist
		 */
		function extend():IAlchemist;
		
	}

}
