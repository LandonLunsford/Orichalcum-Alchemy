package orichalcum.alchemy.configuration.xml.mapper
{
	import flash.utils.getDefinitionByName;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.handler.EventHandler;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.FactoryForwardingProvider;
	import orichalcum.alchemy.provider.ForwardingProvider;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	import orichalcum.utility.XmlUtil;

	public class XmlConfigurationMapper
	{
		private var _expressionQualifier:RegExp;
		private var _expressionRemovals:RegExp;
		private var _factoryMethodNameDelimiter:String;
		private var _reflector:IReflector;
		
		public function XmlConfigurationMapper(reflector:IReflector = null, expressionQualifier:RegExp = null, expressionRemovals:RegExp = null, factoryMethodNameDelimiter:String = '#')
		{
			_reflector = reflector || Reflector.getInstance();
			_expressionQualifier = expressionQualifier || /^{.*}$/;
			_expressionRemovals = expressionRemovals || /{|}|\s/gm;
			_factoryMethodNameDelimiter = factoryMethodNameDelimiter;
		}
		
		public function map(alchemist:IAlchemist, ...configurations):void
		{
			for each(var configuration:* in configurations)
			{
				if (configuration == null)
					throw new ArgumentError('Argument "configurations" contains a null map.');
				
				if (configuration is Array || configuration is Vector.<XML>)
				{
					configuration.unshift(alchemist);
					map.apply(this, configuration);
				}
				else if (configuration is XML)
				{
					_map(alchemist, configuration.children());
				}
				else
				{
					throw new ArgumentError('Argument "configurations" must contain only XML.');
				}
			}
		}
		
		private function _map(alchemist:IAlchemist, mappings:XMLList):void
		{
			for each(var mapping:XML in mappings)
			{
				var id:String = mapping.attribute('id').toString();
				
				if (id == null)
					throw new AlchemyError('The following mapping has no "id" attribute:\n{0}', mapping);
				
				if (id.length == 0)
					throw new AlchemyError('The following mapping has an empty "id" attribute:\n{0}', mapping);
				
				if (mappings.(@id == id).length() > 1)
					throw new AlchemyError('Injection IDs must be unique. The following injections have the same name:\n' + mappings.(@id == id));
				
				const mapper:IAlchemyMapper = alchemist.map(id);
				mapProvider(mapper, mapping, id);
				mapConstructorArguments(mapper, mapping);
				mapProperties(mapper, mapping);
				mapEventHandlers(mapper, mapping);
				mapPostConstruct(mapper, mapping);
				mapPreDestroy(mapper, mapping);
			}
		}
		
		private function mapProvider(mapper:IAlchemyMapper, mapping:XML, id:String):*
		{
			/**
			 * Add syntax error handling to help the user structure their xml properly
			 * 
			 * Also I may want to iterate over the attributes and assure there are not conflicting ones set
			 * 
			 * This is a giant redundant switch statement
			 * whats diff on each:
			 * XML attribute name. "parse" function
			 * 
			 * The below code is highly cooupled with the XML schema
			 */
			
			const to:XMLList = mapping.attribute('to');
			if (to.length() > 0) return mapper.to(parse(to[0]));
			
			const toValue:XMLList = mapping.attribute('to-value');
			if (toValue.length() > 0) return mapper.to(parse(toValue[0]));
			
			const toReference:XMLList = mapping.attribute('to-reference');
			if (toReference.length() > 0) return mapper.toReference(toReference[0].toString());
			
			const toSingleton:XMLList = mapping.attribute('to-singleton');
			if (toSingleton.length() > 0) return mapper.toSingleton(_reflector.getType(toSingleton[0].toString()));
			
			const toPrototype:XMLList = mapping.attribute('to-prototype');
			if (toPrototype.length() > 0) return mapper.toPrototype(_reflector.getType(toPrototype[0].toString()));
			
			const toPool:XMLList = mapping.attribute('to-pool');
			if (toPool.length() > 0) return mapper.toPool(_reflector.getType(toPool[0].toString()));
			
			const toFactory:XMLList = mapping.attribute('to-factory');
			if (toFactory.length() > 0)
			{
				const factory:String = toFactory[0].toString();
				const factoryMethodNameDelimiterIndex:int = factory.lastIndexOf(_factoryMethodNameDelimiter);
				
				if (factoryMethodNameDelimiterIndex == -1)
					throw new AlchemyError('Unable to map "{0}" to factory. Missing "{1}" delimiter in factory definition "{2}". See format: "factoryIdOrClassName#factoryMethodName".', id, _factoryMethodNameDelimiter, factory);
					
				const factoryMethodName:String = factory.substring(factoryMethodNameDelimiterIndex + 1);
				const factoryClassNameOrId:String = factory.substring(0, factoryMethodNameDelimiterIndex);
				return mapper.to(new FactoryForwardingProvider(factoryMethodName, factoryClassNameOrId));
			}
			
			const toProvider:XMLList = mapping.attribute('to-provider');
			if (toProvider.length() > 0)
			{
				const providerType:String = mapping.attribute('to-provider')[0].toString();
				if (providerType == 'singleton') return mapper.asSingleton();
				if (providerType == 'prototype') return mapper.asPrototype();
				if (providerType == 'pool') return mapper.asPool();
				
				// error check for real class? -- good lookahead!
				return mapper.to(new ForwardingProvider(providerType));
			}
			
			mapper.asSingleton();
		}
		
		private function mapConstructorArguments(mapper:IAlchemyMapper, mapping:XML):void
		{
			for each(var constructorArgument:XML in mapping.child('constructor-argument'))
			{
				var constructorArgumentValues:XMLList = constructorArgument.attribute('value');
				
				if (constructorArgumentValues.length() != 1)
					throw new AlchemyError;
				
				mapper.withConstructorArgument(parse(constructorArgumentValues[0]));
			}
		}
		
		private function mapProperties(mapper:IAlchemyMapper, mapping:XML):void
		{
			for each(var property:XML in mapping.child('property'))
			{
				for each(var propertyNode:XML in property.attributes())
				{
					mapper.withProperty(propertyNode.name(), parse(propertyNode));
				}
			}
		}
		
		private function mapEventHandlers(mapper:IAlchemyMapper, mapping:XML):void
		{
			for each(var eventHandler:XML in mapping.child('event-handler'))
				mapEventHandler(mapper, eventHandler);
		}
		
		private function mapEventHandler(mapper:IAlchemyMapper, eventHandler:XML):void 
		{
			var priority:int
				,type:String
				,listener:String
				,targetPath:String
				,useCapture:Boolean
				,stopPropagation:Boolean
				,stopImmediatePropagation:Boolean
				,parameters:Array;
			
			for each(var attribute:XML in eventHandler.attributes())
			{
				var name:String = attribute.name();
				var value:String = attribute.toString();
				
				switch (name.toLowerCase())
				{
					case 'priority':
						priority = int(value);
						break;
						
					case 'usecapture':
						useCapture = value.length > 0 || XmlUtil.valueOf(attribute);
						break;
						
					case 'stoppropagation':
						stopPropagation = value.length > 0 || XmlUtil.valueOf(attribute);
						break;
						
					case 'stopimmediatepropagation':
						stopImmediatePropagation = value.length > 0 || XmlUtil.valueOf(attribute);
						break;
						
					default:
						var nameSplitIndex:int = name.lastIndexOf('.');
						if (nameSplitIndex < 0)
						{
							type = name;
						}
						else
						{
							type = name.substring(nameSplitIndex + 1);
							targetPath = name.substring(0, nameSplitIndex);
						}
						
						var paramSplitIndex:int = value.lastIndexOf('(');
						if (paramSplitIndex < 0)
						{
							listener = value;
						}
						else
						{
							listener = value.substring(0, paramSplitIndex);
							parameters = value.substring(paramSplitIndex).replace(/(\(|\)|\s)/gm,'').split(',');
						}
				}
				
			}
			mapper.withEventHandler(type, listener, targetPath, useCapture, priority, stopPropagation, stopImmediatePropagation, parameters);
		}
		
		private function mapPostConstruct(mapper:IAlchemyMapper, mapping:XML):void
		{
			const postConstructs:XMLList = mapping.child('post-construct');
			if (postConstructs.length() > 1)
			{
				throw new AlchemyError;
			}
			else if (postConstructs.length() == 1)
			{
				const postConstruct:XML = postConstructs[0];
				const postConstructNames:XMLList = postConstruct.attribute('name');
				if (postConstructNames.length() != 1)
					throw new AlchemyError;
				mapper.withPostConstruct(postConstructNames[0].toString());
			}
		}
		
		private function mapPreDestroy(mapper:IAlchemyMapper, mapping:XML):void
		{
			const preDestroys:XMLList = mapping.child('pre-destroy');
			if (preDestroys.length() > 1)
			{
				throw new AlchemyError;
			}
			else if (preDestroys.length() == 1)
			{
				const preDestroy:XML = preDestroys[0];
				const preDestroyNames:XMLList = preDestroy.attribute('name');
				if (preDestroyNames.length() != 1)
					throw new AlchemyError;
				mapper.withPreDestroy(preDestroyNames[0].toString());
			}
		}
		
		/* UTILITY */
		
		private function parse(value:XML):*
		{
			const valueAsString:String = value.toString();
			return _expressionQualifier.test(valueAsString)
				? valueAsString
				: XmlUtil.valueOf(value);
		}
		
	}

}
