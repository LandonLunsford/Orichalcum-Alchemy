package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.ingredient.factory.property;
	import subject.ClassWithTwoQualifiedVariableInjects;
	import subject.ClassWithTwoVariableInjects;
	import subject.ClassWithTwoVariables;

	public class VariableInjectionTest 
	{
		
		private var _alchemist:Alchemist;
		private var _variable0:Point = new Point;
		private var _variable1:Point = new Point;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_alchemist.map('variable0').to(_variable0);
			_alchemist.map('variable1').to(_variable1);
		}
		
		[Test]
		public function testCreateClassWithTwoVariableInjects():void
		{
			const creation:ClassWithTwoVariableInjects = _alchemist.create(ClassWithTwoVariableInjects) as ClassWithTwoVariableInjects;
			assertThat(creation.variable0, notNullValue());
			assertThat(creation.variable1, notNullValue());
		}
		
		[Test]
		public function testCreateClassWithTwoQualifiedVariableInjects():void
		{
			const creation:ClassWithTwoQualifiedVariableInjects = _alchemist.create(ClassWithTwoQualifiedVariableInjects) as ClassWithTwoQualifiedVariableInjects;
			assertThat(_variable0, strictlyEqualTo(creation.variable0));
			assertThat(_variable1, strictlyEqualTo(creation.variable1));
		}
		
		[Test]
		public function testCreateClassWithTwoRuntimeConfiguredVariableInjects():void
		{
			_alchemist.map(ClassWithTwoVariables)
				.add(property('variable0', _variable0))
				.add(property('variable1', _variable1))
				
			const creation:ClassWithTwoVariables = _alchemist.create(ClassWithTwoVariables) as ClassWithTwoVariables;
			assertThat(_variable0, strictlyEqualTo(creation.variable0));
			assertThat(_variable1, strictlyEqualTo(creation.variable1));
		}
		
		[Test]
		public function testRuntimeConfiguredVariablesOverrideStaticConfiguredQualifiedInjects():void
		{
			const override0:Point = new Point;
			
			_alchemist.map(ClassWithTwoQualifiedVariableInjects)
				.add(property('variable0', override0))
			
			const creation:ClassWithTwoQualifiedVariableInjects = _alchemist.create(ClassWithTwoQualifiedVariableInjects) as ClassWithTwoQualifiedVariableInjects;
			assertThat(override0, strictlyEqualTo(creation.variable0));
			assertThat(_variable1, strictlyEqualTo(creation.variable1));
		}
		
	}

}
