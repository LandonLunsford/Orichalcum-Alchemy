package orichalcum.alchemy.mapper
{
	import org.flexunit.runner.manipulation.IFilter;
	
	public interface IAlchemyMapper
	{
		/**
		 * Sets the provider to either a value, reference or provider
		 * @param	providerValueOrReference Any value, reference or provider
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.provider.IProvider
		 */
		function to(providerValueOrReference:*):IAlchemyMapper;
		
		/**
		 * Use this in place of the "to" method when you would like your value to not be parsed as an expression.
		 * @param	value Any value
		 * @return	IAlchemyMapper
		 * @see		#to
		 */
		function toValue(value:*):IAlchemyMapper;
		
		/**
		 * Sets the provider for the mapped ID to another mapped ID's provider
		 * @param	id Custom name, class or qualified class name
		 * @return	IAlchemyMapper
		 */
		function toReference(id:*):IAlchemyMapper;
		
		/**
		 * Sets the provider to "prototype" which will provide a new instance on every request
		 * @param	type Class of the prototype
		 * @return	IAlchemyMapper
		 */
		function toPrototype(type:Class):IAlchemyMapper;
		
		/**
		 * Sets the provider to "singleton" which will provide the same instance on every request
		 * @param	type Class of the singleton
		 * @return	IAlchemyMapper
		 */
		function toSingleton(type:Class):IAlchemyMapper;
		
		/**
		 * Sets the provider to "pool" which will provide a new or recycled instance.
		 * To recycle an instance use orichalcum.alchemy.alchemist.IAlchemist#destroy
		 * @param	type Class of the pool
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#destroy
		 */
		function toPool(type:Class):IAlchemyMapper;
		
		/**
		 * Sets the provider to a factory method
		 * @param	factoryMethod The function returning the value requested
		 * 		function():* {}
		 * 		function(alchemist:IAlchemist = null):* {}
		 * @return	IAlchemyMapper
		 */
		function toFactory(factoryMethod:Function):IAlchemyMapper;
		
		/**
		 * Sets the provider to "prototype" assuming the ID argument used in orichalcum.alchemy.alchemist.IAlchemist#map is the prototype's class.
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function asPrototype():IAlchemyMapper;
		
		/**
		 * Sets the provider to "singleton" assuming the ID argument used in orichalcum.alchemy.alchemist.IAlchemist#map is the prototype's class.
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function asSingleton():IAlchemyMapper;
		
		/**
		 * Sets the provider to "pool" assuming the ID argument used in orichalcum.alchemy.alchemist.IAlchemist#map is the prototype's class.
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function asPool():IAlchemyMapper;
		
		/**
		 * Adds constructor argument values, providers or references to the mapped ID's recipe.
		 * @param	...args	The values, references or providers used to satisfy the objects constructor
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function withConstructorArguments(...args):IAlchemyMapper;
		
		/**
		 * Adds a constructor argument value, provider or reference to the mapped ID's recipe.
		 * @param	value A value, reference or provider used to satisfy the objects constructor
		 * @param	index The index at which the value will be passed to the constructor
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function withConstructorArgument(value:*, index:int = -1):IAlchemyMapper;
		
		/**
		 * Adds all of the properties specified in the property argument to the mapped ID's recipe.
		 * @param	properties Map of property name-value pairs to be injected after object creation
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 */
		function withProperties(properties:Object):IAlchemyMapper;
		
		/**
		 * Add of the properties specified in the property map argument to the mapped ID's recipe.
		 * @param	name The name of the property you wish to provide
		 * @param	value Any value, reference or provider
		 * @return	IAlchemyMapper
		 * @see		orichalcum.alchemy.alchemist.IAlchemist#map
		 * @see		orichalcum.alchemy.provider.IProvider
		 */
		function withProperty(name:String, value:*):IAlchemyMapper;
		
		/**
		 * Sets the post-construct lifecycle hook function of the mapped ID's recipe.
		 * @param	functionName The name of the post-construct function you wish to invoke after object creation
		 * @return	IAlchemyMapper
		 */
		function withPostConstruct(functionName:String):IAlchemyMapper;
		
		/**
		 * Sets the pre-destroy lifecycle hook function of the mapped ID's recipe.
		 * @param	functionName The name of the post-construct function you wish to invoke before object destruction
		 * @return	IAlchemyMapper
		 */
		function withPreDestroy(functionName:String):IAlchemyMapper;
		
		/**
		 * Adds an event handler to the mapped ID's recipe.
		 * @param	type The string-key representing the type of the event (e.g. 'click', 'mouseDown', etc...)
		 * @param	listener The name of the function to invoke when the specified event occurs. This function may accept zero or more arguments. If event parameters are specified however, the function must accept arguments of the type specified by param "parameters".
		 * @param	target The variable name or path to variable on which the event listener will be added.
		 * @param	useCapture Determines whether the listener works in the capture phase or the target and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only during the target or bubbling phase. To listen for the event in all three phases, call addEventListener() twice, once with useCapture set to true, then again with useCapture set to false.
		 * @param	priority The priority level of the event listener. Priorities are designated by a 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
		 * @param	stopPropagation Prevents processing of any event listeners in nodes subsequent to the current node in the event flow.
		 * @param	stopImmediatePropagation Prevents processing of any event listeners in the current node and any subsequent nodes in the event flow.
		 * @param	parameters List of property names to be extracted from the event object and passed to the listener function
		 * @return	IAlchemyMapper
		 */
		function withEventHandler(type:String, listener:String, target:String = null, useCapture:Boolean = false, priority:int = 0, stopPropagation:Boolean = false, stopImmediatePropagation:Boolean = false, parameters:Array = null):IAlchemyMapper;
		
		/**
		 * @TODO
		 */
		function withFriends(...friends):IAlchemyMapper;
	}

}
