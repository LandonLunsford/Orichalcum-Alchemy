package 
{
	import flash.display.Sprite;
	import flash.utils.describeType;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import suite.ComprehensiveTestSuite;

	public class TestRunner extends Sprite
	{
		public function TestRunner()
		{
			const core:FlexUnitCore = new FlexUnitCore;
			core.addListener(new TraceListener);
			core.run(ComprehensiveTestSuite);
		}
		
	}

}
