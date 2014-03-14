package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.recipe.ingredient.factory.property;
	import subject.ClassWithTwoQualifiedSetterInjections;
	import subject.ClassWithTwoSetterInjections;
	import subject.ClassWithTwoSetters;

	public class SetterInjectionTest 
	{
		
		private var _alchemist:Alchemist;
		private var _setter0:Point = new Point;
		private var _setter1:Point = new Point;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_alchemist.map('setter0').to(_setter0);
			_alchemist.map('setter1').to(_setter1);
		}
		
		[Test]
		public function testCreateClassWithTwoSetterInjections():void
		{
			const creation:ClassWithTwoSetterInjections = _alchemist.create(ClassWithTwoSetterInjections) as ClassWithTwoSetterInjections;
			assertThat(creation.setter0, notNullValue());
			assertThat(creation.setter1, notNullValue());
		}
		
		[Test]
		public function testCreateClassWithTwoQualifiedSetterInjections():void
		{
			const creation:ClassWithTwoQualifiedSetterInjections = _alchemist.create(ClassWithTwoQualifiedSetterInjections) as ClassWithTwoQualifiedSetterInjections;
			assertThat(_setter0, strictlyEqualTo(creation.setter0));
			assertThat(_setter1, strictlyEqualTo(creation.setter1));
		}
		
		[Test]
		public function testCreateClassWithTwoRuntimeConfiguredSetterInjects():void
		{
			_alchemist.map(ClassWithTwoSetters)
				.add(property('setter0', _setter0))
				.add(property('setter1', _setter1))
				
			const creation:ClassWithTwoSetters = _alchemist.create(ClassWithTwoSetters) as ClassWithTwoSetters
			assertThat(_setter0, strictlyEqualTo(creation.setter0));
			assertThat(_setter1, strictlyEqualTo(creation.setter1));
		}
		
		[Test]
		public function testRuntimeConfiguredSettersOverrideStaticConfiguredQualifiedInjects():void
		{
			const override0:Point = new Point;
			
			_alchemist.map(ClassWithTwoQualifiedSetterInjections)
				.add(property('setter0', override0))
			
			const creation:ClassWithTwoQualifiedSetterInjections = _alchemist.create(ClassWithTwoQualifiedSetterInjections) as ClassWithTwoQualifiedSetterInjections;
			assertThat(override0, strictlyEqualTo(creation.setter0));
			assertThat(_setter1, strictlyEqualTo(creation.setter1));
		}
		
	}

}
