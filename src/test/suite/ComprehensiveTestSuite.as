package suite
{
	import orichalcum.alchemy.alchemist.AlchemistExtensionTest;
	import orichalcum.alchemy.alchemist.AlchemistTest;
	import orichalcum.alchemy.alchemist.ConstructorArgumentInjectionTest;
	import orichalcum.alchemy.alchemist.EventHandlerTest;
	import orichalcum.alchemy.alchemist.FactoryForwardingMappingTest;
	import orichalcum.alchemy.alchemist.FactoryMappingTest;
	import orichalcum.alchemy.alchemist.FriendTest;
	import orichalcum.alchemy.alchemist.PoolMappingTest;
	import orichalcum.alchemy.alchemist.PostConstructTest;
	import orichalcum.alchemy.alchemist.PreDestroyTest;
	import orichalcum.alchemy.alchemist.PrototypeMappingTest;
	import orichalcum.alchemy.alchemist.ReferenceMappingTest;
	import orichalcum.alchemy.alchemist.SetterInjectionTest;
	import orichalcum.alchemy.alchemist.SingletonMappingTest;
	import orichalcum.alchemy.alchemist.SymbiotTest;
	import orichalcum.alchemy.alchemist.ValueMappingTest;
	import orichalcum.alchemy.alchemist.VariableInjectionTest;
	import orichalcum.alchemy.configuration.xml.mapper.XmlConfigurationMapperTest;
	import orichalcum.alchemy.recipe.CompoundRecipeTest;
	import orichalcum.alchemy.recipe.EmptyRecipeTest;
	import orichalcum.alchemy.recipe.factory.RecipeFactoryTest;
	import orichalcum.alchemy.recipe.FullRecipeTest;

	/*
	 * Testing Debt:
	 * 1. Bindee that doesnt impl IEventDispatcher
	 * 2. Inheritance Model test
	 * 		(referencial recipe linking)
	 * 		(instance fallback on class def recipe linking)
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ComprehensiveTestSuite
	{
		public var alchemistExtensionTest:AlchemistExtensionTest;
		public var alchemistTest:AlchemistTest;
		
		public var constructorArgumentInjectionTest:ConstructorArgumentInjectionTest;
		public var eventHandlerTest:EventHandlerTest;
		public var variableInjectionTest:VariableInjectionTest;
		public var setterInjectionTest:SetterInjectionTest;
		public var postConstructTest:PostConstructTest;
		public var preDestroyTest:PreDestroyTest;
		
		public var valueMappingTest:ValueMappingTest;
		public var referenceMappingTest:ReferenceMappingTest;
		public var factoryForwardingMappingTest:FactoryForwardingMappingTest;
		public var factoryMappingTest:FactoryMappingTest;
		public var prototypeMappingTest:PrototypeMappingTest;
		public var singletonMappingTest:SingletonMappingTest;
		public var poolMappingTest:PoolMappingTest;
		
		public var emptyRecipeTest:EmptyRecipeTest;
		public var fullRecipeTest:FullRecipeTest;
		public var compoundRecipeTest:CompoundRecipeTest;
		
		public var recipeFactoryTest:RecipeFactoryTest;
		
		public var xmlConfigurationMapperTest:XmlConfigurationMapperTest;
		
		public var friendTest:FriendTest;
		public var symbiotTest:SymbiotTest;
		
	}

}
