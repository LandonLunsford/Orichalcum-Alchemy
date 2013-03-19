package orichalcum.alchemy.alchemist 
{
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.provider.mapping.IProviderMapping;
	import orichalcum.alchemy.recipe.IRecipe;
	import orichalcum.alchemy.recipe.Recipe;
	
	 /**
		// 3.8.2013
		// I SUGGEST MAKING DOUBLE API -- standards compliant injector and new alchemist API (use delegate pattern)
				
		orichalcum.alchemy.injector.IInjector		orichalcum.alchemy.alchemist.IAlchemist		
			.map(id):IMapping			.provide().using() .make(x).using(y)	.learn(Point).equals(type(Point)); .assign(Point).to(type(Point)) .make(x).from(y) 
			.unmap(id):IMapping			<!-- just use overwriting -->
			.satisfies(id):IMapping			.knows() .mapped()
			.satisfiesDirectly(id):IMapping		.knowsHimelf()/.wasTaught() .mappedDirectly()
			.describe(id)				.lookup()
			.provide(id)				.conjure()
			.create(id)				.forge() .cook()		
			.disolve(id)				.melt()//retrive provider and ppool it?				
			.injectInto(id)				.infuse .inject
			//.unject(id)				.difuse .unject
			.compose(id)				
			.destroy(id)				
			.bind(id)
			.unbind(id)
			.dispose()
			.createChildInjector()			.createChild() .extend() .propagate()
								.mediate().using()
								.unmediate()
								.learn(recipe)/.remember(recipe) [requires id attribute in recipe]
			.metatags()
			
		orichalcum.alchemy.alchemist.IAlchemist
		orichalcum.alchemy.alchemist.Alchemist
		orichalcum.alchemy.binding.IBinding
		orichalcum.alchemy.binding.Binding
		orichalcum.alchemy.injector.IInjector		// standards compliant decorator for alchemist (keep class name as variable for error messages)
		orichalcum.alchemy.injector.Injector
		orichalcum.alchemy.metatag.IMetatags
		orichalcum.alchemy.metatag.Metatags		
			.injectionMetatag
			.postConstructMetatag
			.preDestroyMetatag
			.eventHandlerMetatag
		orichalcum.alchemy.metatag.IInjectionMetatag	
		orichalcum.alchemy.metatag.IPostConstructMetatag
		orichalcum.alchemy.metatag.IPreDestroyMetatag
		orichalcum.alchemy.metatag.IEventHandlerMetatag
		orichalcum.alchemy.metatag.InjectionMetatag	
		orichalcum.alchemy.metatag.PostConstructMetatag
		orichalcum.alchemy.metatag.PreDestroyMetatag
		orichalcum.alchemy.metatag.EventHandlerMetatag
		orichalcum.alchemy.provider.IProvider		
		orichalcum.alchemy.provider.IInstanceProvider	( exposes type attribute )
		orichalcum.alchemy.provider.FactoryProvider
		orichalcum.alchemy.provider.ForwardingProvider
		orichalcum.alchemy.provider.ValueProvider
		orichalcum.alchemy.provider.ReferenceProvider
		orichalcum.alchemy.provider.PrototypeProvider
		orichalcum.alchemy.provider.SingletonProvider
		orichalcum.alchemy.provider.MultitonProvider
		orichalcum.alchemy.provider.factory.value
		orichalcum.alchemy.provider.factory.reference
		orichalcum.alchemy.provider.factory.type
		orichalcum.alchemy.provider.factory.singleton
		orichalcum.alchemy.provider.factory.multiton
		orichalcum.alchemy.provider.factory.provider
		orichalcum.alchemy.recipe.IRecipeDescription   	// [EXTENDS IRecipeBuilder]
		orichalcum.alchemy.recipe.IRecipe				// mutable aspect of recipe
		orichalcum.alchemy.recipe.IRecipeFactory   		// creates Recipe based on type
		orichalcum.alchemy.recipe.Recipe        		
		orichalcum.alchemy.recipe.NullRecipe
		orichalcum.alchemy.recipe.RecipeFactory

			//metatag schema
			
			IInjectionMetatag
				function get name():String;
				
			IPostConstructMetatag
				function get name():String;
				
			IPreDestroyMetatag
				function get name():String;
				
			IEventHandlerMetatag
				function get name():String;
				function get eventKey():String;
				function get targetKey():String;
				function get parametersKey():String;
				function get priorityKey():String;
				function get useCaptureKey():String;
				function get stopPropagationKey():String;
				function get stopImmediatePropagationKey():String;
				
		[Infuse]	[Inject]
		[Composer]	[PostConstruct]
		[Disposer]	[PreDestroy]
		[Reaction(event="click")]	[EventHandler(event="eventType", target="view.button")]
		
		
	 */
	public interface _IAlchemist 
	{
		/**
		 * Declare each as throwing reference error etc for bad values
		 */
		function provide(id:*):IProviderMapping; // .using(value:IProvider):IRecipe (make alchemist implement IProviderMapping, IMediatorMapping
		function stopProviding(id:*):void;
		function provides(id:*):Boolean;
		function providesDirectly(id:*):Boolean;
		
		//function mediate(view:Class):IMediatorMapping; // .using(mediator:Class):IRecipe; (the mediator's recipe)
		//function stopMediating(id:*):void;
		//function mediates(view:Class):Boolean;
		//function mediatesDirectly(viewClassOrInstance:*):Boolean;
		
		function learn(recipe:Recipe):void;
		function learned(recipe:Recipe):Boolean;
		function unlearn(recipe:Recipe):void; // do an === on the mapped value (ie if (_recipes[recipe.mappingId] !== recipe) fail)
		function lookup(id:*):Recipe; // mutable watchout
		
		function conjure(id:*):*;
		function create(type:Class):Object;
		function inject(instance:Object):Object;
		function bind(instance:Object):Object; // beware of double binding possibility with mediate()
		//function compose(instance:Object):Object;
		function destroy(instance:Object):Object;
		function unbind(instance:Object):Object;
		//function unject(instance:Object):Object;
		
		
		
		function extend():IAlchemist;
		
		function get metatagBundle():IMetatagBundle;
		function set metatagBundle(value:IMetatagBundle):void;
		
		function get expressionQualifier():String;
		function set expressionQualifier(value:String):void;
		
		function evaluate(valueReferenceOrProvider:*):*;
		
	}

}
