package subject 
{
	import flash.geom.Point;

	public class ClassWithMemberAndSetterInject 
	{
		[Inject]
		public var memeberInject:Point;
		
		public var _setterInject:Point;
		
		public function get setterInject():Point
		{
			return _setterInject;
		}
		
		[Inject]
		public function set setterInject(value:Point):void
		{
			_setterInject = value;
		}
		
	}

}