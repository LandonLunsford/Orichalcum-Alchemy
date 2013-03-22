package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
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
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
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
			const argument0:Point = new Point;
			_alchemist.map(ClassWithOneConstructorParameter)
				.withConstructorArgument(argument0);
				
			const creation:ClassWithOneConstructorParameter = _alchemist.create(ClassWithOneConstructorParameter) as ClassWithOneConstructorParameter;
			assertThat(argument0, strictlyEqualTo(creation.constructorArgument0));
		}
		
		[Test]
		public function testCreateTwoParameterClassWithTwoArguments():void
		{
			const argument0:Point = new Point;
			const argument1:Point = new Point;
			_alchemist.map(ClassWithTwoConstructorParameters)
				.withConstructorArgument(argument0)
				.withConstructorArgument(argument1);
				
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(argument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(argument1, strictlyEqualTo(creation.constructorArgument1));
		}
		
		[Test]
		public function testCreateTwoParameterClassWithOneArgument():void
		{
			const argument0:Point = new Point;
			_alchemist.map(ClassWithTwoConstructorParameters)
				.withConstructorArgument(argument0);
				
			const creation:ClassWithTwoConstructorParameters = _alchemist.create(ClassWithTwoConstructorParameters) as ClassWithTwoConstructorParameters;
			assertThat(argument0, strictlyEqualTo(creation.constructorArgument0));
			assertThat(creation.constructorArgument1, notNullValue());
		}
		
	}

}