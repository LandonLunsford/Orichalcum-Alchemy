package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.assertThat;
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.factory.reference;
	import orichalcum.alchemy.provider.factory.singleton;
	import orichalcum.alchemy.provider.factory.type;
	import orichalcum.alchemy.recipe.Recipe;
	import subject.ClassWithAllMetatags;
	import subject.ClassWithMemberAndSetterInject;
	import subject.ClassWithPreDestroy;
	import subject.ClassWithPreDestroyMetatag;


	public class AlchemistTest 
	{
		
		private var _alchemist:IAlchemist;
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		[Test(expects = "ArgumentError")]
		public function testConjureNull():void
		{
			_alchemist.conjure(null);
		}
		
		[Test(expects = "ArgumentError")]
		public function testConjureUndefined():void
		{
			_alchemist.conjure(undefined);
		}
		
		[Test(expects = "ArgumentError")]
		public function testConjureInt():void
		{
			_alchemist.conjure(int(1));
		}
		
		[Test(expects = "ArgumentError")]
		public function testConjureUint():void
		{
			_alchemist.conjure(uint(1));
		}
		
		[Test(expects = "ArgumentError")]
		public function testConjureNumber():void
		{
			_alchemist.conjure(Number(1));
		}
				
		[Test(expects = "ArgumentError")]
		public function testConjureBoolean():void
		{
			_alchemist.conjure(true);
			_alchemist.conjure(false);
		}
		
		[Test(expects = "orichalcum.alchemy.error.AlchemyError")]
		public function testConjureUnmappedId():void
		{
			_alchemist.conjure('unmappedId');
		}
		
		[Test]
		public function testInject():void
		{
			const target:ClassWithMemberAndSetterInject = new ClassWithMemberAndSetterInject;
			assertNull(target.memeberInject);
			assertNull(target.setterInject);
			_alchemist.inject(target);
			assertNotNull(target.memeberInject);
			assertNotNull(target.setterInject);
		}
		
		/**
		 * This test does too much
		 */
		[Test]
		public function testConjureUnmapped():void
		{
			var target:ClassWithAllMetatags = _alchemist.conjure(ClassWithAllMetatags) as ClassWithAllMetatags;
			assertNotNull(target.constructorInject);
			assertNotNull(target.memberInject);
			assertNotNull(target.setterInject);
			assertTrue(target.postConstructCalled);
			assertFalse(target.preDestroyCalled);
			assertFalse(target.eventHandled);
			target.dispatchEventToToggleEventHandled();
			assertTrue(target.eventHandled);
			_alchemist.destroy(target);
			assertTrue(target.preDestroyCalled);
			
			/**
			 * ensures listener was removed
			 * otherwise the value would trigger the handler and be toggled
			 */
			target.dispatchEventToToggleEventHandled();
			assertTrue(target.eventHandled);
		}
		
		[Test]
		public function testConjureMapped():void
		{
			_alchemist.map(ClassWithMemberAndSetterInject).to(type(ClassWithMemberAndSetterInject));
			const target:ClassWithMemberAndSetterInject = _alchemist.conjure(ClassWithMemberAndSetterInject) as ClassWithMemberAndSetterInject;
			assertNotNull(target.memeberInject);
			assertNotNull(target.setterInject);
		}
		
		
		[Test]
		public function testShit():void
		{
			_alchemist.map(Point).to(singleton(Point))
				.withConstructorArgument(1)
				.withConstructorArgument(1);
			assertEquals(1, _alchemist.conjure(Point).x);
			assertEquals(1, _alchemist.conjure(Point).y);
			
			_alchemist.map(Matrix).to(new Matrix)
				.withProperty('a', 1)
				.withPreDestroy('invert');
			assertEquals(1, _alchemist.conjure(Matrix).a);
			
			_alchemist.map('a').to(type(Rectangle));
			
			
			
			_alchemist.map('b').to(reference('a'))
				.withProperty('x', 1);
				
				
			assertFalse(_alchemist.conjure('a')===_alchemist.conjure('b'));
				
			assertEquals(0, _alchemist.conjure('a').x);
			assertEquals(1, _alchemist.conjure('b').x);
			
			_alchemist.map('c').to(reference('b'))
			assertEquals(1, _alchemist.conjure('c').x);
			
			// doesnt inherit b's recipe config as a fallback
			// good?? bad??
			
			_alchemist.conjure(Sprite);
		}
		
		[Test]
		public function testInstanceRecipeMapWithOverwriting():void
		{
			_alchemist.map(ClassWithPreDestroyMetatag);
			const creation:ClassWithPreDestroyMetatag = _alchemist.conjure(ClassWithPreDestroyMetatag) as ClassWithPreDestroyMetatag;
			_alchemist.map(ClassWithPreDestroyMetatag).withPreDestroy('otherPreDestroy');
			_alchemist.destroy(creation);
		}
		
	}

}
