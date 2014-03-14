package orichalcum.alchemy.configuration.xml.mapper
{
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.language.bundle.ILanguageBundle;
	import orichalcum.alchemy.language.bundle.LanguageBundle;
	import orichalcum.alchemy.language.IXmltagLanguage;
	import orichalcum.alchemy.language.xmltag.IConstructorArgumentXmltag;
	import orichalcum.alchemy.language.xmltag.IEventHandlerXmltag;
	import orichalcum.alchemy.language.xmltag.IMapXmltag;
	import orichalcum.alchemy.language.xmltag.IPostConstructXmltag;
	import orichalcum.alchemy.language.xmltag.IPreDestroyXmltag;
	import orichalcum.alchemy.language.xmltag.IPropertyXmltag;
	import orichalcum.alchemy.mapper.IAlchemyMapper;
	import orichalcum.alchemy.provider.FactoryForwardingProvider;
	import orichalcum.alchemy.provider.ForwardingProvider;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	import orichalcum.utility.XmlUtil;

	public class XmlConfigurationMapper
	{
		private var _reflector:IReflector;
		private var _expressionQualifier:RegExp;
		private var _mapXmltag:IMapXmltag;
		private var _constructorArgumentXmltag:IConstructorArgumentXmltag;
		private var _propertyXmltag:IPropertyXmltag;
		private var _eventHandlerXmltag:IEventHandlerXmltag;
		private var _postConstructXmltag:IPostConstructXmltag;
		private var _preDestroyXmltag:IPreDestroyXmltag;
		
		public function XmlConfigurationMapper(reflector:IReflector = null, languageBundle:ILanguageBundle = null)
		{
			_reflector = reflector || Reflector.getInstance();
			languageBundle = languageBundle || new LanguageBundle;
			_expressionQualifier = languageBundle.expressionLanguage.expressionQualifier;
			const language:IXmltagLanguage = languageBundle.xmltagLanguage;
			_mapXmltag = language.mapXmltag;
			_constructorArgumentXmltag = language.constructorArgumentXmltag;
			_propertyXmltag = language.propertyXmltag;
			_eventHandlerXmltag = language.eventHandlerXmltag;
			_postConstructXmltag = language.postConstructXmltag;
			_preDestroyXmltag = language.preDestroyXmltag;
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
					_map(alchemist, configuration.child(_mapXmltag.name));
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
				var id:String = mapping.attribute(_mapXmltag.id).toString();
				
				if (id == null)
					throw new AlchemyError('Required attribute "{0}" not found on "{1}".', _mapXmltag.id, mapping.toString());
				
				if (id.length == 0)
					throw new AlchemyError('Required attribute "{0}" is empty on "{1}".', _mapXmltag.id, mapping);
				
				if (mappings.(@id == id).length() > 1)
					throw new AlchemyError('Injection IDs must be unique. The following injections have the same name:\n' + mappings.(@id == id));
				
				const mapper:IAlchemyMapper = alchemist.map(id);
				mapProvider(mapper, mapping, id);
				mapConstructorArguments(mapper, mapping, id);
				mapProperties(mapper, mapping, id);
				mapEventHandlers(mapper, mapping, id);
				mapPostConstruct(mapper, mapping, id);
				mapPreDestroy(mapper, mapping, id);
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
			
			const to:XML = getSingularAttribute(_mapXmltag.to, mapping, id);
			if (to) return mapper.to(parse(to));
			
			const toValue:XML = getSingularAttribute(_mapXmltag.toValue, mapping, id);
			if (toValue) return mapper.to(parse(toValue));
			
			const toReference:XML = getSingularAttribute(_mapXmltag.toReference, mapping, id);
			if (toReference) return mapper.toReference(toReference.toString());
			
			const toSingleton:XML = getSingularAttribute(_mapXmltag.toSingleton, mapping, id);
			if (toSingleton) return mapper.toSingleton(_reflector.getType(toSingleton.toString()));
			
			const toPrototype:XML = getSingularAttribute(_mapXmltag.toPrototype, mapping, id);
			if (toPrototype) return mapper.toPrototype(_reflector.getType(toPrototype.toString()));
			
			const toPool:XML = getSingularAttribute(_mapXmltag.toPool, mapping, id);
			if (toPool) return mapper.toPool(_reflector.getType(toPool.toString()));
			
			const toFactory:XML = getSingularAttribute(_mapXmltag.toFactory, mapping, id);
			if (toFactory)
			{
				const factory:String = toFactory.toString();
				const factoryMethodNameDelimiterIndex:int = factory.lastIndexOf(_mapXmltag.factoryMethodDelimiter);
				
				if (factoryMethodNameDelimiterIndex == -1)
					throw new AlchemyError('Unable to map "{0}" to factory. Missing "{1}" delimiter in factory definition "{2}". See format: "factoryIdOrClassName#factoryMethodName".', id, _mapXmltag.factoryMethodDelimiter, factory);
					
				const factoryMethodName:String = factory.substring(factoryMethodNameDelimiterIndex + 1);
				const factoryClassNameOrId:String = factory.substring(0, factoryMethodNameDelimiterIndex);
				return mapper.to(new FactoryForwardingProvider(factoryMethodName, factoryClassNameOrId));
			}
			
			const toProvider:XML = getSingularAttribute(_mapXmltag.toProvider, mapping, id);
			if (toProvider)
			{
				const providerType:String = toProvider.toString();
				if (providerType == 'singleton') return mapper.asSingleton();
				if (providerType == 'prototype') return mapper.asPrototype();
				if (providerType == 'pool') return mapper.asPool();
				return mapper.to(new ForwardingProvider(providerType));
			}
			
			mapper.asSingleton();
		}
		
		private function mapConstructorArguments(mapper:IAlchemyMapper, mapping:XML, id:String):void
		{
			for each(var constructorArgument:XML in mapping.child(_constructorArgumentXmltag.name))
				mapper.withConstructorArgument(parse(getRequiredAttribute(_constructorArgumentXmltag.argument, constructorArgument, id)));
		}
		
		private function mapProperties(mapper:IAlchemyMapper, mapping:XML, id:String):void
		{
			for each(var property:XML in mapping.child(_propertyXmltag.name))
			{
				for each(var propertyNode:XML in property.attributes())
				{
					mapper.withProperty(propertyNode.name(), parse(propertyNode));
				}
			}
		}
		
		private function mapEventHandlers(mapper:IAlchemyMapper, mapping:XML, id:String):void
		{
			for each(var eventHandler:XML in mapping.child(_eventHandlerXmltag.name))
				mapEventHandler(mapper, eventHandler, id);
		}
		
		private function mapEventHandler(mapper:IAlchemyMapper, eventHandler:XML, id:String):void 
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
				
				switch (name)
				{
					case _eventHandlerXmltag.priority:
						priority = int(value);
						break;
						
					case _eventHandlerXmltag.useCapture:
						useCapture = value.length > 0 || XmlUtil.valueOf(attribute);
						break;
						
					case _eventHandlerXmltag.stopPropagation:
						stopPropagation = value.length > 0 || XmlUtil.valueOf(attribute);
						break;
						
					case _eventHandlerXmltag.stopImmediatePropagation:
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
							
							/**
							 * This parsing methodology is tightly cupled
							 */
							parameters = value.substring(paramSplitIndex).replace(/(\(|\)|\s)/gm,'').split(',');
						}
				}
				
			}
			mapper.withEventHandler(type, listener, targetPath, useCapture, priority, stopPropagation, stopImmediatePropagation, parameters);
		}
		
		private function mapPostConstruct(mapper:IAlchemyMapper, mapping:XML, id:String):void
		{
			const postConstruct:XML = getSingularChild(_postConstructXmltag.name, mapping, id);
			postConstruct && mapper.withPostConstruct(getRequiredAttribute(_postConstructXmltag.argument, postConstruct, id).toString());
		}
		
		private function mapPreDestroy(mapper:IAlchemyMapper, mapping:XML, id:String):void
		{
			const preDestroy:XML = getSingularChild(_preDestroyXmltag.name, mapping, id);
			preDestroy && mapper.withPreDestroy(getRequiredAttribute(_preDestroyXmltag.argument, preDestroy, id).toString());
		}
		
		private function getSingularChild(childName:String, parent:XML, id:String):XML
		{
			const children:XMLList = parent.child(childName);
			
			if (children.length() > 1)
				throw new AlchemyError('Multiple "<{0}>" elements found on mapping id "{1}" where there is a maximum of one.', childName, id);
				
			if (children.length() < 1)
				return null;
				
			return children[0];
		}
		
		private function getSingularAttribute(attributeName:String, element:XML, id:String):XML
		{
			const values:XMLList = element.attribute(attributeName);
			
			if (values.length() > 1)
				throw new AlchemyError('Multiple "{0}" atrributes found on mapping id "{1}" where there is a maximum of one.', attributeName, id);
			
			if (values.length() < 1)
				return null;
			
			return values[0];
		}
		
		private function getRequiredAttribute(attributeName:String, element:XML, id:String):XML
		{
			const values:XMLList = element.attribute(attributeName);
			
			if (values.length() > 1)
				throw new AlchemyError('Multiple "{0}" atrributes found on "<{1}>" for "{2}" where there is a maximum of one.', attributeName, element.name(), id);
					
			if (values.length() < 1)
				throw new AlchemyError('Required attribute "{0}" not found on "<{1}>" for "{2}".', attributeName, element.name(), id);
			
			return values[0];
		}
		
		private function parse(value:XML):*
		{
			const valueAsString:String = value.toString();
			return _expressionQualifier.test(valueAsString)
				? valueAsString
				: XmlUtil.valueOf(value);
		}
		
	}

}
