package orichalcum.alchemy.alchemist 
{
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import orichalcum.alchemy.provider.factory.factory;
	import orichalcum.alchemy.provider.FactoryForwardingProvider;

	public class FactoryForwardingMappingTest 
	{
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _factoryCalled:Boolean;
		
		private const FACTORY_CLASS_NAME:String = 'orichalcum.alchemy.alchemist::FactoryForwardingMappingTest';
		private const IMAGINARY_FACTORY_METHOD_NAME:String = 'imaginaryFactoryMethod';
		private const STATIC_FACTORY_METHOD_NAME:String = 'staticFactoryMethod';
		private const INSTANCE_FACTORY_METHOD_NAME:String = 'instanceFactoryMethod';
		
		static public const EXPECTED_STATIC_FACTORY_METHOD_RETURN:Number = 1.1;
		static public function staticFactoryMethod():* { return EXPECTED_STATIC_FACTORY_METHOD_RETURN; }
		
		public const EXPECTED_FACTORY_METHOD_RETURN:Number = 1.1;
		public function instanceFactoryMethod():* { return EXPECTED_FACTORY_METHOD_RETURN; }
		
		public function zeroArgumentFactoryMethod():Boolean { return true; }
		public function oneArgumentFactoryMethod(alchemist:IAlchemist):Boolean
		{
			if (alchemist == null) fail();
			return true;
		}
		
		public var notAFunction:Number = 0;
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_factoryCalled = false;
		}
		
		[Test(expects = "Error")]
		public function testNullFactoryMethodName():void
		{
			new FactoryForwardingProvider(null, FACTORY_CLASS_NAME);
		}
		
		[Test(expects = "Error")]
		public function testEmptyFactoryMethodName():void
		{
			new FactoryForwardingProvider('', FACTORY_CLASS_NAME);
		}
		
		[Test(expects = "Error")]
		public function testNullFactoryClassName():void
		{
			new FactoryForwardingProvider(STATIC_FACTORY_METHOD_NAME, null);
		}
		
		[Test(expects = "Error")]
		public function testEmptyFactoryClassName():void
		{
			new FactoryForwardingProvider(STATIC_FACTORY_METHOD_NAME, '');
		}
		
		[Test(expects = "Error")]
		public function testImaginaryFactoryMethod():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider(IMAGINARY_FACTORY_METHOD_NAME, FACTORY_CLASS_NAME));
			_alchemist.conjure(_id);
		}
		
		[Test(expects = "Error")]
		public function testFactoryMethodIsNotAFunction():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider('notAFunction', FACTORY_CLASS_NAME));
			_alchemist.conjure(_id);
		}
		
		[Test]
		public function testStaticFactoryMethod():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider(STATIC_FACTORY_METHOD_NAME, FACTORY_CLASS_NAME));
			assertThat(_alchemist.conjure(_id), equalTo(EXPECTED_STATIC_FACTORY_METHOD_RETURN));
		}
		
		[Test]
		public function testInstanceFactoryMethod():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider(INSTANCE_FACTORY_METHOD_NAME, FACTORY_CLASS_NAME));
			assertThat(_alchemist.conjure(_id), equalTo(EXPECTED_FACTORY_METHOD_RETURN));
		}
		
		[Test]
		public function testZeroArgumentFactoryMethod():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider('zeroArgumentFactoryMethod', FACTORY_CLASS_NAME));
			assertThat(_alchemist.conjure(_id), isTrue());
		}
		
		[Test]
		public function testOneArgumentFactoryMethod():void
		{
			_alchemist.map(_id).to(new FactoryForwardingProvider('oneArgumentFactoryMethod', FACTORY_CLASS_NAME));
			assertThat(_alchemist.conjure(_id), isTrue());
		}
		
	}

}