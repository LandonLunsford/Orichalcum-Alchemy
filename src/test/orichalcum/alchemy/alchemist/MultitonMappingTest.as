package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	import orichalcum.alchemy.provider.factory.multiton;
	import orichalcum.alchemy.provider.factory.type;
	import subject.Multiton;

	public class MultitonMappingTest 
	{
		
		private var _alchemist:Alchemist;
		private var _type:Class = Multiton;
		private var _poolSize:int = 3;
		
		
		[Before]
		public function setup():void
		{
			_alchemist = new Alchemist;
			_alchemist.map(_type).to(multiton(_type, _poolSize));
		}
		
		[Test]
		public function testIsType():void
		{
			assertThat(_alchemist.conjure(_type), isA(_type));
		}
		
		[Test]
		public function testIsNeverTheSameInstance():void
		{
			_type.totalInstances = 0;
			for (var i:int = 100; i >= 0; i--)
				_alchemist.conjure(_type);
				
			assertThat(_type.totalInstances, equalTo(_poolSize));
		}
		
	}

}