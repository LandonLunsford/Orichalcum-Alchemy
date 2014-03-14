package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.recipe.ingredient.EventHandler;
	import orichalcum.utility.ObjectUtil;

	public class EventHandlerProcessor implements IIngredientProcessor
	{
		
		private const MULTIPLE_METATAGS_ERROR_MESSAGE:String = 'Multiple "[{}]" metatags defined in class "{}".';
		private const MULTIPLE_METATAGS_FOR_MEMBER_ERROR_MESSAGE:String = 'Multiple "[{}]" metatags defined for member "{}" of class "{}".';
		private const MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE:String = 'Multiple "{}" attributes found on "[{}]" metatag for member "{}" in class "{}".';
		private const NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE:String = 'Required attribute "{}" not found on "[{}]" metatag for "{}" in class "{}".';
		
		private var _metatagName:String;
		private var _key:String = 'eventHandlers';
		
		public function EventHandlerProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'EventHandler';
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const eventHandlerMetatags:XMLList = methods.metadata.(@name == _metatagName);
			const totalEventHandlers:int = eventHandlerMetatags.length();
			
			for (var j:int = 0; j < totalEventHandlers; j++)
			{
				var handler:EventHandler = new EventHandler;
				var eventHandlerMetadata:XML = eventHandlerMetatags[j];
				var method:XML = eventHandlerMetadata.parent();
				var metatagArgs:XMLList = eventHandlerMetadata.arg;
				var keylessArgs:XMLList = metatagArgs.(@key == '');
				
				handler.listenerName = method.@name.toString();
				
				var targetAndEvent:Array = handler.listenerName.split('_');
				
				var eventArgs:XMLList = metatagArgs.(@key == 'event');
				if (eventArgs.length() == 0 && targetAndEvent.length < 2) throw new AlchemyError(NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE, 'event', _metatagName, typeName);
				if (eventArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'event', _metatagName, handler.listenerName, typeName);
				
				var targetArgs:XMLList = metatagArgs.(@key == 'target');
				if (targetArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'target', _metatagName, handler.listenerName, typeName);
				
				var parameterArgs:XMLList = metatagArgs.(@key == 'parameters');
				if (parameterArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'parameters', _metatagName, handler.listenerName, typeName);
				
				var useCaptureArgs:XMLList = metatagArgs.(@key == 'useCapture');
				if (useCaptureArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'useCapture', _metatagName, handler.listenerName, typeName);
				
				var priorityArgs:XMLList = metatagArgs.(@key == 'priority');
				if (priorityArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'priority', _metatagName, handler.listenerName, typeName);
				
				var stopPropagationArgs:XMLList = metatagArgs.(@key == 'stopPropagation');
				if (stopPropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'stopPropagation', _metatagName, handler.listenerName, typeName);
				
				var stopImmediatePropagationArgs:XMLList = metatagArgs.(@key == 'stopImmediatePropagation');
				if (stopImmediatePropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'stopImmediatePropagation', _metatagName, handler.listenerName, typeName);
				
				var onceArgs:XMLList = metatagArgs.(@key == 'once');
				if (onceArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'once', _metatagName, handler.listenerName, typeName);
				
				
				var relayArgs:XMLList = metatagArgs.(@key == 'relay');
				if (relayArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, 'relay', _metatagName, handler.listenerName, typeName);
				
				if (eventArgs.length() > 0)
				{
					handler.type = eventArgs[0].@value[0].toString();
				}
				else
				{
					handler.type = targetAndEvent[targetAndEvent.length == 1 ? 0 : 1];
				}
				
				if (targetArgs.length() > 0)
				{
					handler.targetPath = targetArgs[0].@value[0].toString();
				}
				else if (targetAndEvent.length > 1)
				{
					handler.targetPath = targetAndEvent[0];
				}
				
				if (relayArgs.length() > 0)
					handler.relayPath = relayArgs[0].@value[0].toString();
				
				if (priorityArgs.length() > 0)
					handler.priority = int(priorityArgs.@value[0]);
					
				if (parameterArgs.length() > 0)
					handler.parameters = parameterArgs[0].@value[0].toString().replace(/\s*/gm, '').split(',');
				
				handler.useCapture = (keylessArgs.(@value == 'useCapture')).length() > 0
					|| useCaptureArgs.length() > 0
					&& useCaptureArgs.@value.toString() == 'true';
					
				handler.stopPropagation = (keylessArgs.(@value == 'stopPropagation')).length() > 0
					|| stopPropagationArgs.length() > 0
					&& stopPropagationArgs.@value.toString() == 'true';
					
				handler.stopImmediatePropagation = (keylessArgs.(@value == 'stopImmediatePropagation')).length() > 0
					|| stopImmediatePropagationArgs.length() > 0
					&& stopImmediatePropagationArgs.@value.toString() == 'true';
					
				handler.once = (keylessArgs.(@value == 'once')).length() > 0
					|| onceArgs.length() > 0
					&& onceArgs.@value.toString() == 'true';
					
				if ((keylessArgs.(@value == 'relay')).length() > 0 || relayArgs.length() > 0)
				{
					handler.relayPath = '__alchemist__';
				}
			
				
				(recipe[_key] ||= []).push(handler);
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is EventHandler)
			{
				(recipe[_key] ||= []).push(ingredient);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			for each(var eventHandler:EventHandler in childRecipe[_key])
			{
				(parentRecipe[_key] ||= []).push(eventHandler);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var eventHandler:EventHandler in recipe[_key])
			{
				var target:Object = ObjectUtil.find(instance, eventHandler.targetPath);
				var targetAsEventDispatcher:IEventDispatcher = target as IEventDispatcher;
				
				if (targetAsEventDispatcher == null)
				{
					if (target === instance)
					{
						throw new AlchemyError('Class "{}" must implement "flash.events::IEventDispatcher" in order to have an event handler with no target specified.', getQualifiedClassName(instance));
					}
					else
					{
						throw new AlchemyError('Variable or child named "{}" could not be found on "{}". Check to make sure that it is public and/or named correctly.', eventHandler.targetPath, instance);
					}
				}
				
				if (!(eventHandler.listenerName in instance))
				{
					throw new AlchemyError('Unable to bind method "{}" to event type "{}". Method "{}" not found on "{}".', eventHandler.listenerName, eventHandler.type, eventHandler.listenerName, getQualifiedClassName(instance));
				}
				
				if (eventHandler.relayPath)
				{
					if (eventHandler.relayPath == '__alchemist__')
					{
						eventHandler.relay = alchemist;
					}
					else
					{
						const relay:Object = ObjectUtil.find(instance, eventHandler.relayPath);
						const relayAsEventDispatcher:IEventDispatcher = relay as IEventDispatcher;
						if (relayAsEventDispatcher == null)
						{
							if (relayAsEventDispatcher === instance)
							{
								throw new AlchemyError('Class "{}" must implement "flash.events::IEventDispatcher" in order to have an event handler with no target specified.', getQualifiedClassName(instance));
							}
							else
							{
								throw new AlchemyError('Variable or child named "{}" could not be found on "{}". Check to make sure that it is public and/or named correctly.', eventHandler.targetPath, instance);
							}
						}
						else if (relayAsEventDispatcher == targetAsEventDispatcher)
						{
							throw new AlchemyError('EventHandler target and relay must not be the same. This will cause an infinite loop.');
						}
						eventHandler.relay = relayAsEventDispatcher;
					}
				}
				
				eventHandler.target = targetAsEventDispatcher;
				eventHandler.listener = instance[eventHandler.listenerName];
				eventHandler.bind();
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var eventHandler:EventHandler in recipe[_key])
			{				
				eventHandler.isBound && eventHandler.unbind();
			}
		}
		
		public function provide(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			/**
			 * Do nothing
			 */
		}
		
		public function configure(xml:XML, alchemist:IAlchemist):void 
		{
			// process xml bean
		}
	}

}
