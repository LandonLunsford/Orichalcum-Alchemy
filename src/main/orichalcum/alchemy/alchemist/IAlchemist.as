package orichalcum.alchemy.alchemist 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.lifecycle.IAlchemyLifecycle;
	import orichalcum.reflection.IReflector;
	
	public interface IAlchemist extends IEventDispatcher, IEvaluator
	{
		
		/**
		 * Maps the ID specified to a provider, recipe or mediator.
		 * @param	id Custom name, class or qualified class name
		 * @return	Provider, recipe and mediator mapper
		 * @see		orichalcum.alchemy.mapper.IAlchemyMapper
		 */
		function map(id:*):IAlchemyMapper;
		
		/**
		 * Unmaps the ID specified to a provider, recipe or mediator.
		 * @param	id Custom name, class or qualified class name
		 */
		function unmap(id:*):void;
		
		/**
		 * Gets or creates an injected object of the type mapped to the ID
		 * based on the provider and recipe mapped to the specified ID.
		 * @param	id Custom name, class or qualified class name
		 * @param	recipe Custom recipe used to override the mapped recipe
		 * @return	An instance of the object type mapped to the ID
		 */
		function conjure(id:*, recipe:Dictionary = null):*;
		
		/**
		 * Creates, injects, calls post-construct hook and returns an object mapped to the ID
		 * based on the provider and recipe mapped to the specified ID.
		 * @param	type The class of the object to create
		 * @param	recipe Custom recipe used to override the mapped recipe
		 * @param	id Internally used to prevent circular dependencies from causeing an infinite loop - set at your own risk
		 * @return	An instance of the object type mapped to the id
		 */
		function create(type:Class, recipe:Dictionary = null, id:* = null):Object;
		
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
		 * @deprecated
		 */
		function extend():IAlchemist;
		
		/**
		 * Sets the parent of the context for dependency heirarchies
		 * I would like to do this but it forces me to expose internal methods
		 */
		//function get parent():IAlchemist;
		//function set parent(value:IAlchemist):void;
		
		function get reflector():IReflector;
		function set reflector(value:IReflector):void;
		
		function get lifecycle():IAlchemyLifecycle;
		
	}

}
