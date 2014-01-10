package orichalcum.alchemy.alchemist
{
	import flash.display.Sprite;
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import subject.SpriteFriend;


	public class FriendTest 
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
				.withFriend(SpriteFriend)
			
			_alchemist.conjure(Sprite);
		}
		
	}

}