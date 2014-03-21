package orichalcum.alchemy.alchemist 
{
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.provider.factory.type;
	import orichalcum.alchemy.ingredient.factory.constructorArgument;
	import subject.ClassWithAllMetatags;

	public class ReferenceMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _id:String = 'id';
		private var _reference:String = 'reference';
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test(expects = "Error")]
		public function testMapToNull():void
		{
			_alchemist.map(_id).to(reference(null));
			_alchemist.conjure(_id);
		}
		
		[Test(expects = "Error")]
		public function testMapToUndefined():void
		{
			_alchemist.map(_id).to(reference(undefined));
			_alchemist.conjure(_id);
		}
		
		[Test]
		public function testMapToReference():void
		{
			const ref:String = 'referenceId';
			_alchemist.map(_id).to(1);
			_alchemist.map(ref).to(reference(_id));
			assertThat(_alchemist.conjure(ref), equalTo(_alchemist.conjure(_id)));
		}
		
		[Test]
		public function testMapToReferenceExpression():void
		{
			const ref:String = 'referenceId';
			_alchemist.map(_id).to(1);
			_alchemist.map(ref).to('{' + _id + '}');
			assertThat(_alchemist.conjure(ref), equalTo(_alchemist.conjure(_id)));
		}
		
		/**
		 * Only tests constructor indirection,
		 * What about everything else?
		 */
		[Test]
		public function testRecipeIndirection():void
		{
			const referenceId:String = 'referenceId';
			const newConstructorInject:Point = new Point(99, 99);
			_alchemist.map(_id).to(type(ClassWithAllMetatags));
			_alchemist.map(referenceId).to(reference(_id))
				.add(constructorArgument(newConstructorInject))
			
			const originalConstructorInject:Point = _alchemist.conjure(_id).constructorInject;
			assertThat(originalConstructorInject, notNullValue());
			assertThat(originalConstructorInject, isA(Point));
			assertThat(originalConstructorInject, not(strictlyEqualTo(newConstructorInject)));
			
			const overridenConstructorInject:Point = _alchemist.conjure(referenceId).constructorInject;
			assertThat(overridenConstructorInject, notNullValue());
			assertThat(overridenConstructorInject, isA(Point));
			assertThat(overridenConstructorInject, strictlyEqualTo(newConstructorInject));
		}

	}

}
