package orichalcum.alchemy.ingredient.processor 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.ingredient.EventHandler;
	import orichalcum.reflection.metadata.transform.IMetadataTransform;
	import orichalcum.reflection.metadata.transform.MetadataMapper;
	import orichalcum.utility.ObjectUtil;

	public class EventHandlerProcessor implements IIngredientProcessor
	{
		
		private var _metatagName:String;
		private var _ingredientId:String = 'eventHandlers';
		private var _alchemistKeyword:String = '__alchemist__';
		private var _mapper:IMetadataTransform = new MetadataMapper()
			.hostname('listenerName')
			.argument('event')
				.to('type')
			.argument('target')
				.to('targetPath')
			.argument('relay')
				.to('relayPath')
				.implicit(_alchemistKeyword)
			.argument('parameters')
				.format(function(value:String):Array {
					return value.replace(/\s*/gm, '').split(',');
				})
		
		public function EventHandlerProcessor(metatagName:String = 'EventHandler')
		{
			_metatagName = metatagName;
		}
		
		public function introspect(typeName:String, typeDescription:XML, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			const methods:XMLList = typeDescription.factory[0].method;
			const eventHandlerMetadata:XMLList = methods.metadata.(@name == _metatagName);
			const totalEventHandlers:int = eventHandlerMetadata.length();
			
			if (totalEventHandlers == 0) return;
			
			var handlers:Array = recipe[_ingredientId] = [];
			
			for each(var metadata:XML in eventHandlerMetadata)
			{
				var handler:EventHandler = _mapper.transform(metadata, new EventHandler) as EventHandler;
				
				/**
				 * Fall back on implicits in listener name
				 */
				if (handler.type == null || handler.targetPath == null)
				{
					var targetAndEventType:Array = handler.listenerName.split('_');
					var totalListenerNameSegments:int = targetAndEventType.length;
					if (handler.type == null && totalListenerNameSegments > 0)
					{
						handler.type = targetAndEventType.pop();
					}
					if (handler.targetPath == null && totalListenerNameSegments > 1)
					{
						handler.targetPath = targetAndEventType.join('.');
					}
				}
				
				handlers.push(handler);
			}
		}
		
		public function add(recipe:Dictionary, ingredient:Object):void
		{
			if (ingredient is EventHandler)
			{
				(recipe[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function inherit(parentRecipe:Dictionary, childRecipe:Dictionary):void 
		{
			for each(var ingredient:* in childRecipe[_ingredientId])
			{
				(parentRecipe[_ingredientId] ||= []).push(ingredient);
			}
		}
		
		public function activate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void
		{
			for each(var handler:EventHandler in recipe[_ingredientId])
			{
				var target:Object = ObjectUtil.find(instance, handler.targetPath);
				var targetAsEventDispatcher:IEventDispatcher = target as IEventDispatcher;
				var relayAsEventDispatcher:IEventDispatcher;
				
				if (targetAsEventDispatcher == null)
				{
					if (target === instance)
					{
						throw new AlchemyError('Class "{}" must implement "flash.events::IEventDispatcher" in order to have an event handler with no target specified.', getQualifiedClassName(instance));
					}
					else
					{
						throw new AlchemyError('Variable or child named "{}" could not be found on "{}". Check to make sure that it is public and/or named correctly.', handler.targetPath, instance);
					}
				}
				
				if (!(handler.listenerName in instance))
				{
					throw new AlchemyError('Unable to bind method "{}" to event type "{}". Method "{}" not found on "{}".', handler.listenerName, handler.type, handler.listenerName, getQualifiedClassName(instance));
				}
				
				if (handler.relayPath)
				{
					if (handler.relayPath == _alchemistKeyword)
					{
						relayAsEventDispatcher = alchemist;
					}
					else
					{
						var relay:Object = ObjectUtil.find(instance, handler.relayPath);
						relayAsEventDispatcher = relay as IEventDispatcher;
						if (relayAsEventDispatcher == null)
						{
							if (relayAsEventDispatcher === instance)
							{
								throw new AlchemyError('Class "{}" must implement "flash.events::IEventDispatcher" in order to have an event handler with no target specified.', getQualifiedClassName(instance));
							}
							else
							{
								throw new AlchemyError('Variable or child named "{}" could not be found on "{}". Check to make sure that it is public and/or named correctly.', handler.targetPath, instance);
							}
						}
						else if (relayAsEventDispatcher == targetAsEventDispatcher)
						{
							throw new AlchemyError('EventHandler target and relay must not be the same. This will cause an infinite loop.');
						}
					}
				}
				
				handler.bind(targetAsEventDispatcher, instance[handler.listenerName], relayAsEventDispatcher);
			}
		}
		
		public function deactivate(instance:*, recipe:Dictionary, alchemist:IAlchemist):void 
		{
			for each(var handler:EventHandler in recipe[_ingredientId])
			{				
				handler.isBound && handler.unbind();
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
			
		}
	}

}
