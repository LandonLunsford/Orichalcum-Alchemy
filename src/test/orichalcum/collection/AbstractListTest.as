package orichalcum.collection 
{
	import flash.errors.IllegalOperationError;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class AbstractListTest 
	{
		
		private var _empty:IList;
		private var _filled:IList;
		
		protected function get newEmptyCollection():IList
		{
			throw new IllegalOperationError('AbstractCollectionTest.newEmptyCollection() is abstract and must be overriden.');
		}
		
		protected function get newFilledCollection():IList
		{
			throw new IllegalOperationError('AbstractCollectionTest.newFilledCollection() is abstract and must be overriden.');
		}
		
		[Before]
		public function setup():void
		{
			_empty = newEmptyCollection;
			_filled = newFilledCollection;
		}
		
		[Test]
		public function testIsEmptyAndClear():void
		{
			assertThat(_empty.isEmpty, isTrue());
			assertThat(_filled.isEmpty, isFalse());
			_filled.clear();
			assertThat(_filled.isEmpty, isTrue());
		}
		
		[Test]
		public function testLength():void
		{
			assertThat(_empty.length, equalTo(0));
			assertThat(_filled.length, equalTo(3));
			_filled.remove(0, 1);
			assertThat(_filled.length, equalTo(1));
		}
		
		[Test]
		public function testAdd():void
		{
			_empty.add(5, 6, 7);
			assertThat(_empty.contains(5, 6, 7), isTrue());
		}
		
		[Test]
		public function testRemove():void
		{
			_filled.remove(0);
			assertThat(_filled.contains(0), isFalse());
			assertThat(_filled.contains(1, 2), isTrue());
			_filled.remove(1, 2);
			assertThat(_filled.isEmpty, isTrue());
		}
		
		[Test]
		public function testContains():void
		{
			assertThat(_filled.contains(0, 1, 2), isTrue());
			assertThat(_empty.contains(999), isFalse());
		}
		
		[Test]
		public function testConcat():void
		{
			assertThat(_empty.concat().isEmpty, isTrue());
			assertThat(_empty.concat(_empty).isEmpty, isTrue());
			
			const emptyConcatFilled:ICollection = _empty.concat(_filled);
			assertThat(emptyConcatFilled.length, equalTo(3));
			assertThat(emptyConcatFilled.toArray(), equalTo([0,1,2]));
			
			const filledConcatEmpty:ICollection = _filled.concat(_empty);
			assertThat(filledConcatEmpty.length, equalTo(3));
			assertThat(filledConcatEmpty.toArray(), equalTo([0,1,2]));
			
			const filledConcatFilled:ICollection = _filled.concat(_filled);
			assertThat(filledConcatFilled.length, equalTo(6));
			assertThat(filledConcatFilled.toArray(), equalTo([0,1,2,0,1,2]));
		}
		
		[Test]
		public function testGetValueOutOfBounds():void
		{
			assertThat(_empty[0], equalTo(undefined));
		}
		
		[Test]
		public function testSetValueOutOfBounds():void
		{
			_empty[4] = 0;
			assertThat(_empty.length, equalTo(5));
		}
		
		[Test]
		public function testGetValue():void
		{
			assertThat(_filled[0], equalTo(0));
			assertThat(_filled[1], equalTo(1));
			assertThat(_filled[2], equalTo(2));
		}
		
		[Test]
		public function testGetValueAfterRemoval():void
		{
			_filled.remove(1);
			assertThat(_filled[1], equalTo(2));
		}
		
		[Test]
		public function testSetValue():void
		{
			const value:int = 999;
			_filled[0] = value;
			_filled[1] = value;
			_filled[2] = value;
			assertThat(_filled.toArray(), equalTo([value, value, value]));
		}
		
		[Test]
		public function testThatValuesCanBeAnything():void
		{
			const values:Array = [
				undefined
				,null
				,int( -99)
				,uint(99)
				,Number(1.11)
				,false
				,true
				,'string'
				,{}
				,Array
				,function():void{}
			];
			
			_empty.add.apply(null, values);
			
			assertThat(_empty.toArray(), equalTo(values));
		}
		
		[Test]
		public function testToArray():void
		{
			assertThat(_empty.toArray(), equalTo([]));
			assertThat(_filled.toArray(), equalTo([0, 1, 2]));
		}
		
		[Test]
		public function testIterable():void
		{
			for each(var nothing:* in _empty) fail();
			for (var i:int = 0; i < _filled.length; i++) _filled[i] = 99;
			assertThat(_filled.toArray(), equalTo([99, 99, 99]));
		}
		
		[Test]
		public function testReverse():void
		{
			assertThat(_empty.reverse().toArray(), equalTo([]));
			assertThat(_filled.reverse().toArray(), equalTo([2, 1, 0]));
		}
		
		[Test]
		public function testSome():void
		{
			const closureA:Function = function(value:*):Boolean { return value == 0; };
			const closureB:Function = function(value:*):Boolean { return value is String; };
			assertThat(_empty.some(closureA), isFalse());
			assertThat(_filled.some(closureA), isTrue());
			assertThat(_filled.some(closureB), isFalse());
		}
		
		[Test]
		public function testEvery():void
		{
			const closureA:Function = function(value:*):Boolean { return value == 0; };
			const closureB:Function = function(value:*):Boolean { return value is Number; };
			assertThat(_empty.every(closureA), isFalse());
			assertThat(_filled.every(closureA), isFalse());
			assertThat(_filled.every(closureB), isTrue());
		}
		
		[Test]
		public function testMap():void
		{
			const closure:Function = function(value:*):* { return value + 5; };
			assertThat(_empty.map(closure).toArray(), equalTo([]));
			assertThat(_filled.map(closure).toArray(), equalTo([5, 6, 7]));
		}
		
		[Test]
		public function testFilter():void
		{
			const closure:Function = function(value:*):* { return value < 2; };
			assertThat(_empty.filter(closure).toArray(), equalTo([]));
			assertThat(_filled.filter(closure).toArray(), equalTo([0, 1]));
		}
		
		//[Test]
		public function testShit():void
		{
			//var cc:CustomCollection = new CustomCollection;
			var list:LinkedList = new LinkedList('a', 'b', 'c');
			list[0] = 'ff';
			for each(var p:* in list)
				trace(p);
				
			
		}
	}

}
