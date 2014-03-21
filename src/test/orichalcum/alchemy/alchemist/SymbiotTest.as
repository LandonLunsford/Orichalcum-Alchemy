package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.ingredient.factory.symbiot;
	import subject.ConstructorSymbiotA;
	import subject.ConstructorSymbiotB;
	import subject.SpriteFriend;
	import subject.SymbiotA;

	
	public class SymbiotTest 
	{
		
		private var _alchemist:IAlchemist;
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
		}
		
		/**
		 * Previously caused infinite loops
		 */
		[Test]
		public function test():void
		{
			_alchemist.map(Sprite)
				.add(symbiot(SpriteFriend))
			
			_alchemist.conjure(Sprite);
		}
		
		[Test]
		public function testInjectionTimeSymbiots():void
		{
			const alchemist:IAlchemist = new Alchemist;
			const a:SymbiotA = alchemist.conjure(SymbiotA) as SymbiotA;
			assertThat(a, strictlyEqualTo(a.symbiotB.symbiotA));
		}
		
		/**
		 * Constructor injection causes infinite loop
		 * To correct this I would have to satisfy constructors with proxies and then inject the actual dependency afterward
		 * This is not always possible though with constructors that have logic beyond setting dependencies
		 * To avoid this use [Inject] + [PostConstruct]
		 */
		[Test(expects = "Error")]
		public function testConstructionTimeSymbiots():void
		{
			const alchemist:IAlchemist = new Alchemist;
			const a:ConstructorSymbiotA = alchemist.conjure(ConstructorSymbiotA) as ConstructorSymbiotA;
			assertThat(a, strictlyEqualTo(a.b.a));
		}
		
	}

}