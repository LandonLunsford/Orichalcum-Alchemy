(Orichalcum-Alchemy)
====================
_alchemist.map('spell.point').to(type(Point));
_alchemist.map('spell.matrix').to(new Matrix(0,0,0)); // value assumed
_alchemist.map('spell.casting.time').to(value(1000));

orichalcum.alchemist.IAlchemist
orichalcum.alchemist.Alchemist  	(internally use _elements:Dictionary<String,ElementProfile>)
orichalcum.alchemist.aspect.IDisposable	(dispose)
orichalcum.alchemist.aspect.IExtendable	(extend)
orichalcum.alchemist.guise.IProvider	(provide)
orichalcum.alchemist.guise.ICreator	(create)
orichalcum.alchemist.guise.IInjector	(inject/unject)
orichalcum.alchemist.guise.IBinder	(bind/unbind)
orichalcum.alchemist.guise.IComposer	(compose)
orichalcum.alchemist.guise.IDestroyer	(compose)
orichalcum.alchemist.guise.IConjurur	(new profile)
orichalcum.alchemist.guise.IMapper	(map,unmap)
orichalcum.alchemist.guise.IMapping	(to,from)
orichalcum.alchemist.guise.IAnalist	(analyze)

orichalcum.alchemist.metal.provider.FactoryProvider
orichalcum.alchemist.metal.provider.ForwardingProvider
orichalcum.alchemist.metal.provider.ValueProvider
orichalcum.alchemist.metal.provider.ReferenceProvider
orichalcum.alchemist.metal.provider.PrototypeProvider
orichalcum.alchemist.metal.provider.SingletonProvider
orichalcum.alchemist.metal.provider.MultitonProvider
orichalcum.alchemist.metal.provider.factory.value
orichalcum.alchemist.metal.provider.factory.reference
orichalcum.alchemist.metal.provider.factory.type
orichalcum.alchemist.metal.provider.factory.singleton
orichalcum.alchemist.metal.provider.factory.multiton
orichalcum.alchemist.metal.provider.factory.provider
orichalcum.alchemist.metal.analysis.IElementAnalysis	// readonly aspect of spell
orichalcum.alchemist.metal.analysis.IElementBuilder		// mutable aspect of spell
orichalcum.alchemist.metal.analysis.ElementAlchemy		(IElementAnalysis/IElementBuilder)
orichalcum.alchemist.metal.analyzer.IElementAnalyzer	// creates ElementAlchemy based on type
// spell factory is the only consumer of these, so how will it be configurable? -- pass alchemist, with config (should be user configurable)
orichalcum.alchemist.metal.metatag.InjectionMetatag
orichalcum.alchemist.metal.metatag.ReactionMetatag
orichalcum.alchemist.metal.metatag.CompositionMetatag
orichalcum.alchemist.metal.metatag.DisposalMetatag
[Inject]	[Inject]
[Composer]	[PostConstruct]
[Disposer]	[PreDestroy]
[Reaction]	[EventHandler(trigger="eventType", target="view.button")]
orichalcum.alchemist.elemental.reactor.IReactor
orichalcum.alchemist.elemental.reactor.Reactor

// rewrite for orichalcum.alchemist.element.analysis.*
orichalcum.alchemy.recipe.IRecipe           // readonly aspect of recipe [EXTENDS IRecipeBuilder]
orichalcum.alchemy.recipe.IRecipeBuilder		// mutable aspect of recipe
orichalcum.alchemy.recipe.Recipe        		(IElementAnalysis/IElementBuilder)
orichalcum.alchemy.recipe.IRecipeFactory   	// creates Recipe based on type

orichalcum.alchemy.alchemist
orichalcum.alchemy.alchemist.guise
orichalcum.alchemy.core.
orichalcum.alchemy.metal.
orichalcum.alchemy.crystal.
orichalcum.alchemy.ingot.
orichalcum.alchemy.gem.
orichalcum.alchemy.mineral.
orichalcum.alchemy.element.
orichalcum.alchemy.element.


orichalcum.alchemy.alchemist
orichalcum.alchemy.recipe.

orichalcum.alchemy.alchemist.IAlchemist
orichalcum.alchemy.alchemist.Alchemist				:IAlchemist -- id validation layer, has AlchemistApprentice
// internals
orichalcum.alchemy.alchemist.AlchemistApprentice	:IAlchemist -- delegation layer, has engineer, evaluator, mapper x3
orichalcum.alchemy.alchemist.InstanceEngineer		-- needs evaluator for evaluating provider values
orichalcum.alchemy.alchemist.ExpressionEvaluator	-- needs AlchemistApprentice for conjureing, expressionQualifiers:RegExp
orichalcum.alchemy.alchemist.RecipeMapper			-- has recipes, needs RecipeFactory, needs IMetatagBundle
orichalcum.alchemy.alchemist.ProviderMapper			-- has providers, needs RecipeFactory, needs IMetatagBundle
orichalcum.alchemy.alchemist.MediatorMapper			-- has mediators, needs alchemist

// Existing gap,

I should not expose user to Recipe Class, but only IRecipe
change api to the following:

alchemist.cook('soup')
	.withConstructorArgument('{soup.chicken}')
	.withProperty('salt', 0);
	.withDisposer('simmerDown');

this way I can proxy all access to the Recipe Class, and wrap all arguments in providers, removing the need for the
"evaluate" function, though it allows for a smaller data-footpriint


		static public function merge(flyweightArray:Array = null, ...arrays):Array
		{
			flyweightArray ||= [];
			flyweightArray.length = 0;
			var i:int;
			for each(var array:Array in arrays)
			{
				if (array == null || array.length == 0) continue;
				
				while (i < array.length)
					flyweightArray[i] = array[i++];
			}
			return flyweight;
		}
		
		private function mergeRecipes(a:Recipe, b:Recipe):Recipe
		{
			const c:Recipe = new Recipe;
			
			/* flyweight */
			
			// add clear() function;
			
			/**
			 * utilize object util.
			 */
			
			c.hasConstructorArguments && c.constructorArguments.length = 0;
			if (c.hasProperties) ObjectUtil.empty(c.properties);
			c.hasBindings && c.bindings.length = 0;
			c.hasComposer && c.composer = null;
			c.hasDisposer && c.disposer = null;
			
			/**
			 * I could make an array utility function for this
			 */
			
			ArrayUtil.merge(c.constructorArguments, a, b);
			ObjectUtil.extend(c, b);
			ObjectUtil.extend(c, a);
			b.hasBindings && c.bindings.push.apply(null, b.binding);
			a.hasBindings && c.bindings.push.apply(null, a.binding);
			c.composer = a.composer || b.composer;
			c.disposer = a.disposer || b.disposer;
		}














