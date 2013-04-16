package orichalcum.alchemy.configuration.xml.mapper
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.FactoryForwardingProvider;
	import orichalcum.utility.XmlUtil;

	public class XmlConfigurationMapper
	{
		
		private var _expressionQualifier:RegExp;
		private var _expressionRemovals:RegExp;
		private var _factoryMethodNameDelimiter:String;
		
		public function XmlConfigurationMapper(expressionQualifier:RegExp, expressionRemovals:RegExp, factoryMethodNameDelimiter:String = '#')
		{
			_expressionQualifier = expressionQualifier;
			_expressionRemovals = expressionRemovals;
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
				
				const mapper:IAlchemyMapper = getMapper(alchemist, getId(mapping));
				mapProvider(mapper, mapping);
				mapConstructorArguments(mapper, mapping);
				mapProperties(mapper, mapping);
				mapEventHandlers(mapper, mapping);
				mapPostConstruct(mapper, mapping);
				mapPreDestroy(mapper, mapping);
			}
		}
		
		private function mapProvider(mapper:IMapper, mapping:XML):void
		{
			/**
			 * Add syntax error handling to help the user structure their xml properly
			 *
			 * Also I may want to iterate over the attributes and assure there are not conflicting ones set
			 */
			
			const to:XMLList = mapping.attribute('to');
			if (to.length() > 0) return void(mapper.to(parse(to)));
			
			const toValue:XMLList = mapping.attribute('to-value');
			if (toValue.length() > 0) return void(mapper.to(parse(toValue)));
			
			const toReference:XMLList = mapping.attribute('to-reference');
			if (toReference.length() > 0) return void(mapper.toReference(getDefinitionByName(toReference.toString())));
			
			const toSingleton:XMLList = mapping.attribute('to-singleton');
			if (toSingleton.length() > 0) return void(mapper.toSingleton(getDefinitionByName(toSingleton.toString())));
			
			const toPrototype:XMLList = mapping.attribute('to-prototype');
			if (toPrototype.length() > 0) return void(mapper.toPrototype(getDefinitionByName(toPrototype.toString())));
			
			const toPool:XMLList = mapping.attribute('to-pool');
			if (toPool.length() > 0) return void(mapper.toPool(getDefinitionByName(toPool.toString())));
			
			const toProvider:XMLList = mapping.attribute('to-provider');
			if (toProvider.length() > 0)
			{
				const providerType:String = _parser.parseToProvider(mapping);
				if (providerType == 'singleton') return void(mapper.asSingleton());
				if (providerType == 'prototype') return void(mapper.asPrototype());
				if (providerType == 'pool') return void(mapper.asPool());
				const factoryMethodNameDelimiterIndex:int = providerType.lastIndexOf(_factoryMethodNameDelimiter);
				if (functionNameDelimiterIndex == -1) return void(mapper.toReference(providerType));
				const factoryMethodName:String = providerType.substring(functionNameDelimiterIndex + 1);
				const factoryName:String = providerType.substring(0, functionNameDelimiterIndex);
				mapper.to(new FactoryForwardingProvider(factoryMethodName, factoryName));
			}
			else
			{
				mapper.asSingleton();
			}
		}
		
		private function mapConstructorArguments(mapper:IMapper, mapping:XML):void
		{
			for each(var constructorArgument:XML in mapping.child('constructor-argument'))
			{
				var constructorArgumentValues:XMLList = constructorArgument.attribute('value');
				
				if (constructorArgumentValues.length() != 0)
					throw new AlchemyError;
				
				mapper.withConstructorArgument(parse(constructorArgumentValue[0]));
			}
		}
		
		private function mapProperties(mapper:IMapper, mapping:XML):void
		{
			for each(var property:XML in mapping.child('property'))
			{
				for each(var propertyNode:XML in property.attributes())
				{
					mapper.withProperty(propertyNode.name(), parse(propertyNode));
				}
			}
		}
		
		private function mapEventHandlers(mapper:IMapper, mapping:XML):void
		{
			for each(var eventHandler:XML in mapping.child('event-handler'))
			{
				for each(var attribute:XML in eh.attributes())
				{
					var name:String = attribute.name();
					var value:String = attribute.toString();
					
					switch (name.toLowerCase())
					{
						case 'priority':
							eventHandler.priority = int(value);
							break;
							
						case 'usecapture':
							eventHandler.useCapture = value.length > 0 || XmlUtil.valueOf(attribute);
							break;
							
						case 'stoppropagation':
							eventHandler.stopPropagation = value.length > 0 || XmlUtil.valueOf(attribute);
							break;
							
						case 'stopimmediatepropagation':
							eventHandler.stopImmediatePropagation = value.length > 0 || XmlUtil.valueOf(attribute);
							break;
							
						default:
							var nameSplitIndex:int = name.lastIndexOf('.');
							if (nameSplitIndex < 0)
							{
								eventHandler.type = name;
							}
							else
							{
								eventHandler.type = name.substring(nameSplitIndex + 1);
								eventHandler.targetPath = name.substring(0, nameSplitIndex);
							}
							
							var paramSplitIndex:int = value.lastIndexOf('(');
							if (paramSplitIndex < 0)
							{
								eventHandler.listenerName = value;
							}
							else
							{
								eventHandler.listenerName = value.substring(0, paramSplitIndex);
								eventHandler.parameters = value.substring(paramSplitIndex).replace(/(\(|\)|\s)/gm,'').split(',');
							}
					}
				}
			}
		}
		
		private function mapPostConstruct(mapper:IMapper, mapping:XML):void
		{
			const postConstructs:XMLList = mapping.attribute('post-construct');
			if (postConstructs.length() > 1)
			{
				throw new AlchemyError;
			}
			else if (postConstructs.length() == 0)
			{
				mapper.withPostConstruct(postConstructs[0].name().toString());
			}
		}
		
		private function mapPreDestroy(mapper:IMapper, mapping:XML):void
		{
			const preDestroys:XMLList = mapping.attribute('pre-destroy');
			if (preDestroys.length() > 1)
			{
				throw new AlchemyError;
			}
			else if (preDestroys.length() == 0)
			{
				mapper.withPreDestroy(preDestroys[0].name().toString());
			}
		}
		
		/* UTILITY */
		
		private function parse(value:XML):*
		{
			const valueAsString:String = value.toString();
			if (_expressionQualifier.test(valueAsString))
				return valueAsString.replace(_expressionRemovals, '');
			return XmlUtil.valueOf(value);
		}
		
	}

}
