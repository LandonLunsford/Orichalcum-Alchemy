package suite
{
	import orichalcum.alchemy.alchemist.AlchemistExtensionTest;
	import orichalcum.alchemy.alchemist.AlchemistTest;
	import orichalcum.alchemy.alchemist.ConstructorArgumentInjectionTest;
	import orichalcum.alchemy.alchemist.EventHandlerTest;
	import orichalcum.alchemy.alchemist.FactoryForwardingMappingTest;
	import orichalcum.alchemy.alchemist.FactoryMappingTest;
	import orichalcum.alchemy.alchemist.PoolMappingTest;
	import orichalcum.alchemy.alchemist.PostConstructTest;
	import orichalcum.alchemy.alchemist.PreDestroyTest;
	import orichalcum.alchemy.alchemist.PrototypeMappingTest;
	import orichalcum.alchemy.alchemist.ReferenceMappingTest;
	import orichalcum.alchemy.alchemist.SetterInjectionTest;
	import orichalcum.alchemy.alchemist.SignalHandlerTest;
	import orichalcum.alchemy.alchemist.SingletonMappingTest;
	import orichalcum.alchemy.alchemist.SymbiotTest;
	import orichalcum.alchemy.alchemist.ValueMappingTest;
	import orichalcum.alchemy.alchemist.VariableInjectionTest;
	import orichalcum.alchemy.processor.EventHandlerProcessorTest;
	import orichalcum.reflection.metadata.transform.MetadataTransformTest;
	
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ComprehensiveTestSuite
	{
		//public var alchemistExtensionTest:AlchemistExtensionTest;
		//public var alchemistTest:AlchemistTest;
		//
		//public var constructorArgumentInjectionTest:ConstructorArgumentInjectionTest;
		public var eventHandlerTest:EventHandlerTest;
		public var signalHandlerTest:SignalHandlerTest;
		//public var variableInjectionTest:VariableInjectionTest;
		//public var setterInjectionTest:SetterInjectionTest;
		//public var postConstructTest:PostConstructTest;
		//public var preDestroyTest:PreDestroyTest;
		//public var symbiotTest:SymbiotTest;
		//
		//public var valueMappingTest:ValueMappingTest;
		//public var referenceMappingTest:ReferenceMappingTest;
		//public var factoryForwardingMappingTest:FactoryForwardingMappingTest;
		//public var factoryMappingTest:FactoryMappingTest;
		//public var prototypeMappingTest:PrototypeMappingTest;
		//public var singletonMappingTest:SingletonMappingTest;
		//public var poolMappingTest:PoolMappingTest;
		
		public var eventHandlerProcessorTest:EventHandlerProcessorTest;
		
		// these must be rewritten
		//public var xmlConfigurationMapperTest:XmlConfigurationMapperTest;
		
		public var metadataTransformTest:MetadataTransformTest;
	}

}
