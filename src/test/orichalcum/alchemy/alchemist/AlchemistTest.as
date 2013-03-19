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

	/**
	 * Need to make list of all the fascets I want to test
	 * In the regression tests I should only test against the Alchemist interface
	 * and other client-consumed items (orichalcum.provider.factory.*)
	 * 
	 * Next test recipe, and recipe extension ?
	 * 
	 * Regression
	 * Need to test Id validation layer
	 * 		feed all arguments
	 * 
	 * function conjure(id:*, recipe:Recipe = null):*
	 * 
	 * 
	 * function provide(id:*):IProviderMapper
	 * 
	 * 
	 * function cook(id:*):IRecipeMapper;
	 * 
	 * 
	 * function create(type:Class, recipe:Recipe = null):Object;
	 * function inject(instance:Object, recipe:Recipe = null):Object;
	 * function destroy(instance:Object, recipe:Recipe = null):Object;
	 * 
	 * 
	 * 
		// modularity
		function extend():IAlchemist;
		
		// configuration
		function get metatagBundle():IMetatagBundle;
		function set metatagBundle(value:IMetatagBundle):void;
		
		function get expressionQualifier():String;
		function set expressionQualifier(value:String):void;
	 */
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
				.withDisposer('invert');
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
		
	}

}
