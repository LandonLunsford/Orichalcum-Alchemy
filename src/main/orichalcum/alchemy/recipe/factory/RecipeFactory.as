package orichalcum.alchemy.recipe.factory 
{

	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import orichalcum.alchemy.binding.Binding;
	import orichalcum.alchemy.error.AlchemyError;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;


	public class RecipeFactory implements IDisposable
	{
		private var _reflector:IReflector
		private var _metatagBundle:IMetatagBundle;
		private var _typeRecipes:Dictionary;
		
		public function RecipeFactory(reflector:IReflector, metatagBundle:IMetatagBundle)
		{
			_reflector = reflector || Reflector.getInstance();
			_metatagBundle = metatagBundle;
			_typeRecipes = new Dictionary;
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
			/**
			 * Hotfix
			 */
			if (qualifiedClassName === 'Object')
				return new Recipe;
			
			const typeDescription:XML = describeType(reflector.getType(qualifiedClassName));
			const factory:XML = typeDescription.factory[0];
			const superclass:String = factory.extendsClass.@type[0].toString();
			
			return _reflector.isNativeType(superclass)
				? createRecipeFromFactory(qualifiedClassName, factory)
				: getRecipeByClassName(superclass).clone().extend(createRecipeFromFactory(qualifiedClassName, factory));
		}
		
		public function createRecipeFromFactory(typeName:String, typeFactory:XML):Recipe
		{
			const recipe:Recipe = new Recipe;
			const methods:XMLList = typeFactory.method;
			const constructorParameterTypes:XMLList = typeFactory.constructor.parameter.@type;
			const constructorArgumentInjections:XMLList = typeFactory.metadata.(@name == metatagBundle.injectionMetatag.name).arg.@value;
			const propertyInjectees:XMLList = typeFactory.variable + typeFactory.accessor.(@access != 'readonly');
			const totalArgumentInjections:int = constructorArgumentInjections.length();
			const totalRequiredConstructorParameters:int = typeFactory.constructor.parameter.(@optional == 'false').length();
			
			// Constructor Injections
			for (var i:int = 0; i < totalArgumentInjections; i++)
			{
				recipe.constructorArguments[i] = reference(constructorArgumentInjections[i].toString());
			}
			for (; i < totalRequiredConstructorParameters; i++)
			{
				recipe.constructorArguments[i] = reference(constructorParameterTypes[i].toString());
			}
			
			// Property Injections
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
				if (propertyInjections.length() > 1)
				{
					throw new AlchemyError('Multiple injections defined for "{0}.{1}"', typeName, propertyName);
				}
				if (propertyInjections.arg.length() > 1)
				{
					throw new AlchemyError('Multiple injections defined for "{0}.{1}"', typeName, propertyName);
				}
			}
			
			if (methods.metadata.length() > 0)
			{
				// Post Construct
				const postConstructs:XMLList = methods.(@declaredBy == typeName).metadata.(@name == metatagBundle.postConstructMetatag.name);
				if (postConstructs.length() > 1)
				{
					throw new AlchemyError('Multiple "[{0}]" methods found in "{1}"', metatagBundle.postConstructMetatag.name, typeName);
				}
				if (postConstructs.length() > 0)
				{
					recipe.composer = postConstructs[0].parent().@name;
				}
					
				// Pre Destroy
				const preDestroys:XMLList = methods.(@declaredBy == typeName).metadata.(@name == metatagBundle.preDestroyMetatag.name);
				if (preDestroys.length() > 1)
				{
					throw new AlchemyError('Multiple "[{0}]" methods found in "{1}"', metatagBundle.preDestroyMetatag.name, typeName);
				}
				if (preDestroys.length() > 0)
				{
					recipe.disposer = preDestroys[0].parent().@name;
				}
				
				// Event Handlers
				const eventHandlerMetatags:XMLList = methods.metadata.(@name == metatagBundle.eventHandlerMetatag.name);
				const totalEventHandlers:int = eventHandlerMetatags.length();
				
				for (var j:int = 0; j < totalEventHandlers; j++)
				{
					var eventHandlerMetadata:XML = eventHandlerMetatags[j];
					var metatagArgs:XMLList = eventHandlerMetadata.arg;
					var eventArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.eventKey);
					
					// throw error? ignore? -- failfast -- ignore would drop a null in the handlers pool making it nullpointer exception prone
					if (eventArgs.length() == 0) throw new SyntaxError(); 
					if (eventArgs.length() > 1) throw new SyntaxError();
					
					var targetArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.targetKey);
					if (targetArgs.length() > 1) throw new SyntaxError();
					
					var parameterArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.parametersKey);
					if (parameterArgs.length() > 1) throw new SyntaxError();
					
					var useCaptureArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.useCaptureKey);
					if (useCaptureArgs.length() > 1) throw new SyntaxError();
					
					var priorityArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.priorityKey);
					if (priorityArgs.length() > 1) throw new SyntaxError();
					
					var stopPropagationArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.stopPropagationKey);
					if (stopPropagationArgs.length() > 1) throw new SyntaxError();
					
					var stopImmediatePropagationArgs:XMLList = metatagArgs.(@key == metatagBundle.eventHandlerMetatag.stopImmediatePropagationKey);
					if (stopImmediatePropagationArgs.length() > 1) throw new SyntaxError();
					
					var keylessArgs:XMLList = metatagArgs.(@key == '');
					var method:XML = eventHandlerMetadata.parent();
					var handler:Binding = new Binding;
					
					if (eventArgs.length() > 0)
						handler.type = eventArgs[0].@value[0].toString();
					
					if (targetArgs.length() > 0)
						handler.targetPath = targetArgs[0].@value[0].toString();
					
					if (priorityArgs.length() > 0)
						handler.priority = int(priorityArgs.@value[0]);
						
					if (parameterArgs.length() > 0)
						handler.parameters = parameterArgs[0].@value[0].toString().replace(new RegExp('\ ', 'g'), '').split(',');
					
					handler.listenerName = method.@name.toString(); // last time this called the function...
					
					handler.useCapture = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.useCaptureKey)).length() > 0
						|| useCaptureArgs.length() > 0
						&& useCaptureArgs.@value.toString() == 'true';
						
					handler.stopPropagation = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.stopPropagationKey)).length() > 0
						|| stopPropagationArgs.length() > 0
						&& stopPropagationArgs.@value.toString() == 'true';
						
					handler.stopImmediatePropagation = (keylessArgs.(@value == metatagBundle.eventHandlerMetatag.stopImmediatePropagationKey)).length() > 0
						|| stopImmediatePropagationArgs.length() > 0
						&& stopImmediatePropagationArgs.@value.toString() == 'true';
					
					recipe.bindings.push(handler);
				}
			}
			return recipe;
		}
		
	}

}
