package orichalcum.utility 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	public class Random extends Object
	{
		
		
		static public function nonRepeatingInteger(min:int, max:int, previous:int):int
		{
			if (min == max) return min;
			var random:int = integer(min, max);
			while (random == previous)
				random = integer(min, max);
			return random;
		}
		
		/**
		 * @param	probability Value between 0 and 1 indicating the chance of true
		 * @return	True if the random generated is below the probability specified
		 */
		static public function boolean(probability:Number = 0.5):Boolean
		{
			return Math.random() < probability;
		}
		
		/**
		 * @param	min The minimum possible value to return
		 * @param	max The maximum possible value to return
		 * @return	Random Number between param min and max
		 */
		static public function number(min:Number, max:Number):Number
		{
			return min + Math.random() * (max - min);
		}
		
		/**
		 * @param	min The minimum possible value to return
		 * @param	max The maximum possible value to return
		 * @return	Random int between param min and max
		 */
		static public function integer(min:int, max:int):int
		{
			return int(min + Math.random() * (max - min));
		}
		
		/**
		 * @param	min The minimum possible value to return
		 * @param	max The maximum possible value to return
		 * @return	Random uint between param min and max
		 */
		static public function unsigned(min:uint, max:uint):uint
		{
			return uint(Math.round(min + Math.random() * (max - min)));
		}
		
		/**
		 * @param	array	The array from which a random element will be selected and returned
		 * @return	Random element from the array specified by param 'array'
		 */
		static public function elementOf(array:Array):*
		{
			return array[integer(0, array.length - 1)];
		}
		
		/**
		 * @param	array	The array whose elements will be rearranged randomly
		 * @return	Randomized array
		 */
		static public function scramble(array:Array):Array
		{
			var length:int = array.length;
			for (var i:int = length - 1; i >= 0; i--)
			{
				var j:int = length * Math.random() | 0;
				
				if (j == i) continue;
				
				var temp:* = array[j];
				array[j] = array[i];
				array[i] = temp;
			}
			return array;
		}
		
		/**
		 * @return	Random uint between 0x000000 and 0xffffff
		 */
		static public function get color():uint
		{
			return unsigned(0x000000, 0xffffff);
		}
		
		/**
		 * @return	Random Number between 0 and 360
		 */
		static public function get angle():Number
		{
			return number(-180, 180);
		}
		
		/**
		 * @return	Number between 0 and object width
		 */
		static public function containerX(object:DisplayObject):Number
		{
			return number(0, object is Stage ? Stage(object).stageWidth : object.width);
		}
		
		/**
		 * @return	Number between 0 and object height
		 */
		static public function containerY(object:DisplayObject):Number
		{
			return number(0, object is Stage ? Stage(object).stageHeight : object.width);
		}
		
		/**
		 * @return
		 */
		static public function gridX(gridWidth:Number, spacingX:Number):Number
		{
			return number(0, gridWidth) * spacingX;
		}
		
	}
	
}