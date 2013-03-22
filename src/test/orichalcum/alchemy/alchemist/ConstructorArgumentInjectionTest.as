package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.notNullValue;
	import subject.ClassWithOneConstructorParameter;
	import subject.ClassWithTwoConstructorParameters;
	import subject.ClassWithZeroConstructorParameters;

	public class ConstructorArgumentInjectionTest 
	{
		
		private var _alchemist:Alchemist;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Ignore]
		[Test]
		public function testCreateZeroParameterClassWithZeroArguments():void
		{
			_alchemist.create(ClassWithZeroConstructorParameters);
		}
		
		[Ignore]
		[Test]
		public function testCreateOneParameterClassWithZeroArguments():void
		{
			const creation:ClassWithOneConstructorParameter = _alchemist.create(ClassWithOneConstructorParameter) as ClassWithOneConstructorParameter;
			assertThat(creation.constructorArgument0, notNullValue());
		}
		
		[Ignore]
		[Test]
		public function testCreateTwoParameterClassWithZeroArguments():void
		{
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(creation.constructorArgument0, notNullValue());
			assertThat(creation.constructorArgument1, notNullValue());
		}
		
		[Test(expects = "Error")]
		public function testCreateZeroParameterClassWithOneArgument():void
		{
			_alchemist.map(ClassWithZeroConstructorParameters)
				//.asPrototype()
				.withConstructorArgument(new Point);
				
			_alchemist.conjure(ClassWithZeroConstructorParameters);
		}
		
	}

}