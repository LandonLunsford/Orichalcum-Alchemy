package 
{
	import flash.display.Sprite;
	import flexunit.framework.TestSuite;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	public class TestRunner extends Sprite
	{
		public function TestRunner()
		{
			const core:FlexUnitCore = new FlexUnitCore;
			core.addListener(new TraceListener);
			core.run(TestSuite);
		}
		
	}

}
