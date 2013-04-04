package orichalcum.alchemy.recipe.factory 
{
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import orichalcum.alchemy.metatag.bundle.IMetatagBundle;
	import orichalcum.alchemy.metatag.bundle.StandardMetatagBundle;
	import orichalcum.alchemy.recipe.factory.RecipeFactory;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.reflection.IReflector;
	import orichalcum.reflection.Reflector;
	import subject.ClassWithAllMetatags;
	import subject.ClassWithNoMetatags;

	public class RecipeFactoryTest 
	{
		
		static private var _recipeFactory:RecipeFactory;
		static private var _hasEverything:Recipe;
		static private var _hasNothing:Recipe;
		
		[BeforeClass]
		static public function setup():void
		{
			_recipeFactory = new RecipeFactory(Reflector.getInstance(), new StandardMetatagBundle);
			_hasEverything = _recipeFactory.getRecipeForClass(ClassWithAllMetatags);
			_hasNothing = _recipeFactory.getRecipeForClass(ClassWithNoMetatags);
		}
		
		[AfterClass]
		static public function teardown():void
		{
			_recipeFactory = null;
			_hasEverything = null;
			_hasNothing = null;
		}
		
		[Test]
		public function testHasConstructorArguments():void
		{
			assertTrue(_hasEverything.hasConstructorArguments);
		}
		
		[Test]
		public function testHasNoConstructorArguments():void
		{
			assertFalse(_hasNothing.hasConstructorArguments);
		}
		
		[Test]
		public function testHasEventHandlers():void
		{
			assertTrue(_hasEverything.hasEventHandlers);
		}
		
		[Test]
		public function testHasNoEventHandlers():void
		{
			assertFalse(_hasNothing.hasEventHandlers);
		}
		
		[Test]
		public function testHasComposer():void
		{
			assertTrue(_hasEverything.hasComposer);
		}
		
		[Test]
		public function testHasNoComposer():void
		{
			assertFalse(_hasNothing.hasComposer);
		}
		
		[Test]
		public function testHasDisposer():void
		{
			assertTrue(_hasEverything.hasDisposer);
		}
		
		[Test]
		public function testHasNoDisposer():void
		{
			assertFalse(_hasNothing.hasDisposer);
		}
		
		[Test]
		public function testHasProperties():void
		{
			assertTrue(_hasEverything.hasProperties);
		}
		
		[Test]
		public function testHasNoProperties():void
		{
			assertFalse(_hasNothing.hasProperties);
		}
		
		[Ignore]
		[Test]
		public function debugTrace():void
		{
			var recipe:Recipe = _hasEverything;
			trace(recipe.constructorArguments);
			trace(recipe.eventHandlers);
			trace(recipe.postConstruct);
			trace(recipe.preDestroy);
			trace(recipe.properties);
		}
		
	}

}
