package orichalcum.alchemy.alchemist
{
	import orichalcum.alchemy.alchemist.Alchemist;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import subject.ClassWithSignalHandlerMetatags;

	public class SignalHandlerTest 
	{
		
		[Test]
		public function test():void
		{
			const alchemist:IAlchemist = new Alchemist;
			const mediator:ClassWithSignalHandlerMetatags = alchemist.conjure(ClassWithSignalHandlerMetatags) as ClassWithSignalHandlerMetatags;
			
			trace('-----------sig test-------------', mediator.target.signal.has(mediator.target_signal));

		}
		
	}

}