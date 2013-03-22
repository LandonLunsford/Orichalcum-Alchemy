package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import subject.ClassWithOneConstructorParameter;
	import subject.ClassWithTwoConstructorParameters;
	import subject.ClassWithTwoConstructorParametersAndTwoConstructorInjects;
	import subject.ClassWithZeroConstructorParameters;
	import subject.ClassWithZeroConstructorParametersAndOneConstructorInject;

	public class ConstructorArgumentInjectionTest 
	{
		
		private var _alchemist:Alchemist;
		private var _constructorArgument0:Point = new Point;
		private var _constructorArgument1:Point = new Point;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test]
		public function testCreateZeroParameterClassWithZeroArguments():void
		{
			_alchemist.create(ClassWithZeroConstructorParameters);
		}
		
		[Test]
		public function testCreateOneParameterClassWithZeroArguments():void
		{
			const creation:ClassWithOneConstructorParameter = _alchemist.create(ClassWithOneConstructorParameter) as ClassWithOneConstructorParameter;
			assertThat(creation.constructorArgument0, notNullValue());
		}
		
		[Test]
		public function testCreateTwoParameterClassWithZeroArguments():void
		{
			const creation:ClassWithTwoConstructorParameters = _alchemist.conjure(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(creation.constructorArgument0, notNullValue());
			assertThat(creation.constructorArgument1, notNullValue());
		}
		
		[Test(expects = "Error")]
		public function testCreateZeroParameterClassWithOneArgument():void
		{
			_alchemist.map(ClassWithZeroConstructorParameters)
				.withConstructorArgument(new Point);
				
			_alchemist.conjure(ClassWithZeroConstructorParameters);
		}
		
		[Test]
		public function testCreateOneParameterClassWithOneArgument():void
		{
			_alchemist.map(ClassWithOneConstructorParameter)
				.withConstructorArgument(_constructorArgument0);
				
			const creation:ClassWithOneConstructorParameter = _alchemist.create(ClassWithOneConstructorParameter) as ClassWithOneConstructorParameter;
			assertThat(_constructorArgument0, strictlyEqualTo(creation.constructorArgument0));
		}
		
		[Test]
		public function testCreateTwoParameterClassWithTwoArguments():void
		{
			_alchemist.map(ClassWithTwoConstructorParameters)
				.withConstructorArgument(_constructorArgument0)
				.withConstructorArgument(_constructorArgument1);
				
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(_constructorArgument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(_constructorArgument1, strictlyEqualTo(creation.constructorArgument1));
		}
		
		[Test]
		public function testCreateTwoParameterClassWithOneArgument():void
		{
			_alchemist.map(ClassWithTwoConstructorParameters)
				.withConstructorArgument(_constructorArgument0);
				
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(_constructorArgument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(creation.constructorArgument1, notNullValue());
		}
		
		[Test(expects = "Error")]
		public function testCreateClassWithZeroConstructorParametersAndOneMetadataInject():void
		{
			_alchemist.create(ClassWithZeroConstructorParametersAndOneConstructorInject);
		}
		
		[Test]
		public function testCreateClassWithTwoConstructorParametersAndTwoConstructorInjects():void
		{
			_alchemist.map('constructorArgument0').to(_constructorArgument0);
			_alchemist.map('constructorArgument1').to(_constructorArgument1);
			const creation:ClassWithTwoConstructorParametersAndTwoConstructorInjects = _alchemist.create(ClassWithTwoConstructorParametersAndTwoConstructorInjects) as ClassWithTwoConstructorParametersAndTwoConstructorInjects;
			assertThat(_constructorArgument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(_constructorArgument1, strictlyEqualTo(creation.constructorArgument1));
		}
		
		[Test]
		public function testStaticConstructorInjectOverrideWithRuntimeConfiguration():void
		{
			_alchemist.map(ClassWithTwoConstructorParametersAndTwoConstructorInjects)
				.withConstructorArgument(_constructorArgument0)
				.withConstructorArgument(_constructorArgument1);
				
			const creation:ClassWithTwoConstructorParametersAndTwoConstructorInjects = _alchemist.create(ClassWithTwoConstructorParametersAndTwoConstructorInjects) as ClassWithTwoConstructorParametersAndTwoConstructorInjects;
			assertThat(_constructorArgument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(_constructorArgument1, strictlyEqualTo(creation.constructorArgument1));
		}
		
	}

}
