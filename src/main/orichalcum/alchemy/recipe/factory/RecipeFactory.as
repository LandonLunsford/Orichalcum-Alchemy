package orichalcum.alchemy.recipe.factory 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.handler.EventHandler;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;


	public class RecipeFactory implements IDisposable
	{
		static private const MULTIPLE_METATAGS_ERROR_MESSAGE:String = 'Multiple "[{0}]" metatags defined in class "{2}".';
		static private const MULTIPLE_METATAGS_FOR_MEMBER_ERROR_MESSAGE:String = 'Multiple "[{0}]" metatags defined for member "{1}" of class "{2}".';
		static private const MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE:String = 'Multiple "{0}" attributes found on "[{1}]" metatag for member "{2}" in class "{3}".';
		static private const NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE:String = 'Required attribute "{0}" not found on "[{1}]" metatag for "{2}" in class "{3}".';
		
		private var _reflector:IReflector
		private var _metatagBundle:IMetatagBundle;
		private var _typeRecipes:Dictionary;
		
		public function RecipeFactory(reflector:IReflector, metatagBundle:IMetatagBundle)
		{
			_reflector = reflector || Reflector.getInstance();
			_metatagBundle = metatagBundle;
			_typeRecipes = new Dictionary;
			
			/**
			 * Defensively priming cache with basic types
			 */
			const basicTypes:Array = [Object, Array, Function, Class, Number, String, int, uint, Boolean];
			for each(var type:Class in basicTypes)
				_typeRecipes[_reflector.getTypeName(type)] = new Recipe;
		}
		
		/* INTERFACE orichalcum.lifecycle.IDisposable */
		
		public function dispose():void 
		{
			for (var recipeName:String in _typeRecipes)
			{
				_typeRecipes[recipeName] is IDisposable && (_typeRecipes[recipeName] as IDisposable).dispose();
				delete _typeRecipes[recipeName];
			}
			_typeRecipes = null;
			_reflector = null;
			_metatagBundle = null;
		}
		
		public function get reflector():IReflector 
		{
			return _reflector;
		}
		
		public function set reflector(value:IReflector):void 
		{
			_reflector = value;
		}
		
		public function get metatagBundle():IMetatagBundle 
		{
			return _metatagBundle;
		}
		
		public function set metatagBundle(value:IMetatagBundle):void 
		{
			_metatagBundle = value;
		}
		
		public function getRecipeForClass(classOrInstance:*):Recipe
		{
			return getRecipeByClassName(getQualifiedClassName(classOrInstance));
		}
		
		public function getRecipeByClassName(qualifiedClassName:String):Recipe
		{
			return _typeRecipes[qualifiedClassName] ||= createRecipe(qualifiedClassName);
		}
		
		public function createRecipe(qualifiedClassName:String):Recipe
		{
			const typeDescription:XML = describeType(reflector.getType(qualifiedClassName));
			const factory:XML = typeDescription.factory[0];
			const superclasses:XMLList = factory.extendsClass.@type;
			
			/* 
			 * Ideally I would like to do this somewhere else
			 * But it is convenient and efficient to catch this error here.
			 */
			if (superclasses.length() == 0)
				throw new AlchemyError('Alchemists cannot create "{0}" because it is an interface and cannot be instantiated.', qualifiedClassName);
			
			const superclassName:String = superclasses[0].toString();
			return _reflector.isNativeType(superclassName)
				? createRecipeFromFactory(qualifiedClassName, factory)
				: getRecipeByClassName(superclassName).clone().extend(createRecipeFromFactory(qualifiedClassName, factory));
		}
		
		public function createRecipeFromFactory(typeName:String, typeFactory:XML):Recipe
		{
			const recipe:Recipe = new Recipe;
			
			addConstructorArguments(recipe, typeName, typeFactory);
			addProperties(recipe, typeName, typeFactory);
			
			const methods:XMLList = typeFactory.method;
			if (methods.metadata.length() > 0)
			{
				addPostConstruct(recipe, typeName, methods);
				addPreDestroy(recipe, typeName, methods);
				addEventHandlers(recipe, typeName, methods);
			}
			
			return recipe;
		}
		
		private function addConstructorArguments(recipe:Recipe, typeName:String, typeFactory:XML):void 
		{
			const constructorParameterTypes:XMLList = typeFactory.constructor.parameter.@type;
			const constructorArgumentInjections:XMLList = typeFactory.metadata.(@name == metatagBundle.injectionMetatag.name).arg.@value;
			const totalArgumentInjections:int = constructorArgumentInjections.length();
			const totalRequiredConstructorParameters:int = typeFactory.constructor.parameter.(@optional == 'false').length();
			
			for (var i:int = 0; i < totalArgumentInjections; i++)
			{
				recipe.constructorArguments[i] = reference(constructorArgumentInjections[i].toString());
			}
			for (; i < totalRequiredConstructorParameters; i++)
			{
				recipe.constructorArguments[i] = reference(constructorParameterTypes[i].toString());
			}
		}
		
		private function addProperties(recipe:Recipe, typeName:String, typeFactory:XML):void 
		{
			const propertyInjectees:XMLList = typeFactory.variable + typeFactory.accessor.(@access != 'readonly');
			
			for each (var propertyInjectee:XML in propertyInjectees)
			{
				var propertyInjections:XMLList = propertyInjectee.metadata.(@name == metatagBundle.injectionMetatag.name);
				if (propertyInjections.length() == 0) continue;
				
				var propertyName:String = propertyInjectee.@name.toString();
				var propertyType:String = propertyInjectee.@type.toString();
				
				if (propertyInjections.arg.length() > 0)
				{
					recipe.properties[propertyName] = reference(propertyInjections.arg[0].@value.toString());
				}
				else if (reflector.isComplexType(propertyType)) 
				{
					recipe.properties[propertyName] = reference(propertyType);
				}
				if (propertyInjections.length() > 1 || propertyInjections.arg.length() > 1)
				{
					throw new AlchemyError(MULTIPLE_METATAGS_ERROR_MESSAGE, metatagBundle.injectionMetatag.name, propertyName, typeName);
				}
			}
		}
		
		private function addPostConstruct(recipe:Recipe, typeName:String, methods:XMLList):void 
		{
			const postConstructs:XMLList = methods.(@declaredBy == typeName).metadata.(@name == metatagBundle.postConstructMetatag.name);
			
			if (postConstructs.length() > 1)
				throw new AlchemyError(MULTIPLE_METATAGS_ERROR_MESSAGE, metatagBundle.postConstructMetatag.name, typeName);
				
			if (postConstructs.length() > 0)
				recipe.postConstruct = postConstructs[0].parent().@name;
		}
		
		private function addPreDestroy(recipe:Recipe, typeName:String, methods:XMLList):void 
		{
			const preDestroys:XMLList = methods.(@declaredBy == typeName).metadata.(@name == metatagBundle.preDestroyMetatag.name);
			
			if (preDestroys.length() > 1)
				throw new AlchemyError(MULTIPLE_METATAGS_ERROR_MESSAGE, metatagBundle.preDestroyMetatag.name, typeName);
				
			if (preDestroys.length() > 0)
				recipe.preDestroy = preDestroys[0].parent().@name;
		}
			
		private function addEventHandlers(recipe:Recipe, typeName:String, methods:XMLList):void 
		{
			const eventHandlerMetatags:XMLList = methods.metadata.(@name == metatagBundle.eventHandlerMetatag.name);
			const totalEventHandlers:int = eventHandlerMetatags.length();
			
			for (var j:int = 0; j < totalEventHandlers; j++)
			{
				var handler:EventHandler = new EventHandler;
				var eventHandlerMetadata:XML = eventHandlerMetatags[j];
				var method:XML = eventHandlerMetadata.parent();
				var metatagArgs:XMLList = eventHandlerMetadata.arg;
				var keylessArgs:XMLList = metatagArgs.(@key == '');
				
				handler.listenerName = method.@name.toString();
				
				var eventArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.eventKey);
				if (eventArgs.length() == 0) throw new AlchemyError(NO_REQUIRED_METATAG_ATTRIBUTE_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.eventKey, metatagBundle.preDestroyMetatag.name, typeName);
				if (eventArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.eventKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var targetArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.targetKey);
				if (targetArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.targetKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var parameterArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.parametersKey);
				if (parameterArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.parametersKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var useCaptureArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.useCaptureKey);
				if (useCaptureArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.useCaptureKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var priorityArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.priorityKey);
				if (priorityArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.priorityKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var stopPropagationArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.stopPropagationKey);
				if (stopPropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.stopPropagationKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				var stopImmediatePropagationArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.stopImmediatePropagationKey);
				if (stopImmediatePropagationArgs.length() > 1) throw new AlchemyError(MULTIPLE_METATAG_ATTRIBUTES_ERROR_MESSAGE, metatagBundle.eventHandlerMetatag.stopImmediatePropagationKey, metatagBundle.eventHandlerMetatag.name, handler.listenerName, typeName);
				
				if (eventArgs.length() > 0)
					handler.type = eventArgs[0].@value[0].toString();
				
				if (targetArgs.length() > 0)
					handler.targetPath = targetArgs[0].@value[0].toString();
				
				if (priorityArgs.length() > 0)
					handler.priority = int(priorityArgs.@value[0]);
					
				if (parameterArgs.length() > 0)
					handler.parameters = parameterArgs[0].@value[0].toString().replace(new RegExp('\ ', 'g'), '').split(',');
				
				handler.useCapture = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.useCaptureKey)).length() > 0
					|| useCaptureArgs.length() > 0
					&& useCaptureArgs.@value.toString() == 'true';
					
				handler.stopPropagation = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.stopPropagationKey)).length() > 0
					|| stopPropagationArgs.length() > 0
					&& stopPropagationArgs.@value.toString() == 'true';
					
				handler.stopImmediatePropagation = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.stopImmediatePropagationKey)).length() > 0
					|| stopImmediatePropagationArgs.length() > 0
					&& stopImmediatePropagationArgs.@value.toString() == 'true';
				
				recipe.eventHandlers.push(handler);
			}
		}
		
	}

}
