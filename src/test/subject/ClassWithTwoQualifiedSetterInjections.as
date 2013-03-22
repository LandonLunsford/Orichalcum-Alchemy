package subject 
{
	import flash.geom.Point;

	public class ClassWithTwoQualifiedSetterInjections 
	{
		private var _setter0:Point;
		private var _setter1:Point;
		
		public function get setter0():Point 
		{
			return _setter0;
		}
		
		[Inject('setter0')]
		public function set setter0(value:Point):void 
		{
			_setter0 = value;
		}
		
		public function get setter1():Point 
		{
			return _setter1;
		}
		
		[Inject('setter1')]
		public function set setter1(value:Point):void 
		{
			_setter1 = value;
		}

	}

}
