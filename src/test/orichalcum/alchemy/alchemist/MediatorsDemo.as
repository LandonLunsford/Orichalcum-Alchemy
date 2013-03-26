package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import subject.Mediator;

	public class MediatorsDemo extends Sprite
	{
		
		private var _alchemist:IAlchemist = new Alchemist;
		
		public function MediatorsDemo() 
		{
			_alchemist.map(Sprite).withMediator(Mediator);
			
			const s:Sprite = _alchemist.conjure(Sprite) as Sprite;
			addChild(s);
			removeChild(s);
		}
		
	}

}
