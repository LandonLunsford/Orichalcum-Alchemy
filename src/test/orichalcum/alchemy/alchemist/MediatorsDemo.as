package orichalcum.alchemy.alchemist 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import subject.Mediator;

	public class MediatorsDemo extends Sprite
	{
		
		private var _alchemist:IAlchemist = new Alchemist;
		
		public function MediatorsDemo() 
		{
			_alchemist.map(Sprite).withMediator(Mediator);
			_alchemist.map(Sprite).asSingleton();
			const s:Sprite = _alchemist.conjure(Sprite) as Sprite;
			addChild(s);
			s.dispatchEvent(new Event(Event.COMPLETE));
			removeChild(s);
		}
		
	}

}
