package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;

	public class MediatorsDemo extends Sprite
	{
		
		private var _alchemist:IAlchemist = new Alchemist;
		
		public function MediatorsDemo() 
		{
			_alchemist.map(Sprite).withMediator(new PoopyMediator);
		}
		
	}

}
