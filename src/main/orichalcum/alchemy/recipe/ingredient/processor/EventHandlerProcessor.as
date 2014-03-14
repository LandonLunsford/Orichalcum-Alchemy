package orichalcum.alchemy.recipe.ingredient.processor 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.recipe.ingredient.EventHandler;


	public class EventHandlerProcessor implements IIngredientProcessor
	{
		private var _metatagName:String;
		private var _key:String = 'eventHandlers';
		
		public function EventHandlerProcessor(metatagName:String = null) 
		{
			_metatagName = metatagName ? metatagName : 'EventHandler';
		}
		
		public function create(typeName:String, typeDescription:XML, recipe:Dictionary):void 
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
				//if (eventArgs.length() == 0 && targetAndEvent.length < 2) throw new AlchemyError(NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE, _eventHandlerMetatag.eventKey, _preDestroyMetatag.name, typeName);
				//if (eventArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.eventKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var targetArgs:XMLList = metatagArgs.(@key == 'target');
				//if (targetArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.targetKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var parameterArgs:XMLList = metatagArgs.(@key == 'parameters');
				//if (parameterArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.parametersKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var useCaptureArgs:XMLList = metatagArgs.(@key == 'useCapture');
				//if (useCaptureArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.useCaptureKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var priorityArgs:XMLList = metatagArgs.(@key == 'priority');
				//if (priorityArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.priorityKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var stopPropagationArgs:XMLList = metatagArgs.(@key == 'stopPropagation');
				//if (stopPropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.stopPropagationKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var stopImmediatePropagationArgs:XMLList = metatagArgs.(@key == 'stopImmediatePropagation');
				//if (stopImmediatePropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, _eventHandlerMetatag.stopImmediatePropagationKey, _eventHandlerMetatag.name, handler.listenerName, typeName);
				
				if (eventArgs.length() > 0)
				{
					handler.type = eventArgs[0].@value[0].toString();
				}
				else if (targetAndEvent.length >= 2)
				{
					handler.type = targetAndEvent[1];
				}
				
				if (targetArgs.length() > 0)
				{
					handler.targetPath = targetArgs[0].@value[0].toString();
				}
				else if (targetAndEvent.length >= 1)
				{
					handler.targetPath = targetAndEvent[0];
				}
				
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
				
				(recipe[_key] ||= []).push(handler);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			for each(var eventHandler:EventHandler in childRecipe[_key])
			{
				(parentRecipe[_key] ||= []).push(eventHandler);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
		public function deactivate(instance:*, recipe:Dictionary):void 
		{
			
		}
		
	}

}