package orichalcum.utility 
{
	
	public class ArrayUtil
	{
		
		static public function rotate(array:Array, columns:int, right:Boolean = true, times:int = 1):int
		{
			switch(right ? times % 4 : 4 - (times % 4))
			{
				case 1: return rotateRight(array, columns);
				case 2: return rotateAround(array, columns);
				case 3: return rotateLeft(array, columns);
			}
			return columns;
		}
		
		static public function rotateRight(array:Array, columns:int):int
		{
			var rows:int = array.length / columns;
			
			for (var col:int = 0; col < columns; col++)
				for (var row:int = rows - 1; row >= 0; row--)
					array.push(array[row * columns + col]);
					
			array.splice(0, array.length * 0.5);
			return rows;
		}
		
		static public function rotateLeft(array:Array, columns:int):int
		{
			var rows:int = array.length / columns;
			
			for (var col:int = columns - 1; col >= 0; col--)
				for (var row:int = 0; row < rows; row++)
					array.push(array[row * columns + col]);
			
			array.splice(0, array.length * 0.5);
			return rows;
		}
		
		static public function rotateAround(array:Array, columns:int):int
		{
			var rows:int = array.length / columns;
			
			for (var row:int = rows - 1; row >= 0; row--)
				for (var col:int = columns - 1; col >= 0; col--)
					array.push(array[row * columns + col]);
			
			array.splice(0, array.length * 0.5);
			return columns;
		}
		
		static public function flipHorizontally(array:Array, columns:int):void
		{
			var rows:int = array.length / columns;
			
			for (var row:int = 0; row < rows; row++)
				for (var col:int = columns - 1; col >= 0; col--)
					array.push(array[row * columns + col]);
			
			array.splice(0, array.length * 0.5);
		}
		
		static public function flipVertically(array:Array, columns:int):void
		{
			var rows:int = array.length / columns;
			
			for (var row:int = rows - 1; row >= 0; row--)
				for (var col:int = 0; col < columns; col++)
					array.push(array[row * columns + col]);
			
			array.splice(0, array.length * 0.5);
		}
		
		/**
		 * @param	array The array whose elements order will be modified
		 * @param	comparator function(item1:*, item2:*):int [-1:less, 0:equal, 1:greater]
		 */
		static public function insertionSort(array:Array, comparator:Function):void
		{
			if (array.length < 2) return;
			
			var size:uint = array.length;
			for (var i:uint = 1; i < size; i++)
			{
				var item:* = array[i];
				for (var j:uint = i; j > 0 && comparator(array[j - 1], item) == 1; --j)
				{
					array[j] = array[j - 1];
				}
				array[j] = item;
			}
		}
		
		static public function randomize(array:Array):void
		{
			var i:uint = array.length;

			if (i < 2) return;
			
			var j:uint;
			var o:*;
			while (--i)
			{
				j = Math.floor(Math.random() * (i + 1));
				o = array[i];
				array[i] = array[j];
				array[j] = o;
			}
		}
		
		static public function linearize(array2d:Array):Array
		{
			if (!array2d || array2d.length < 2 || !(array2d[0] is Array)) 
				return array2d;
				
			var result:Array = [];
			for each(var array:Array in array2d)
				for each(var item:* in array)
					result.push(item);
					
			return result;
		}
		
		static public function quadraticize(array1d:Array, width:int):Array
		{
			if (!array1d || array1d.length < 2 || width < 1)
				return array1d;

			var result:Array = [];
			var height:int = array1d.length / width;
			for (var i:int = 0; i < height; i++)
			{
				result[i] = [];
				for (var j:int = 0; j < width; j++)
					result[i].push(array1d[i * width + j]);
			}
			
			return result;
		}
		
		static public function transpose(array2d:Array):Array
		{
			if (!array2d || array2d.length < 2)
				return array2d;
			
			var result:Array = [];
			var height:int = array2d.length;
			var width:int = array2d[0].length;
			for (var j:int = 0; j < width; j++)
			{
				result[j] = [];
				for (var i:int = 0; i < height; i++)
					result[j][i] = array2d[i][j];
			}
			
			return result;
		}

		static public function rotateMatrix(matrix:Array, right:Boolean = true, times:int = 1):Array
		{
			if (!matrix || matrix.length < 2 || !(matrix[0] is Array))
				return matrix;
			
			times %= 4;
			if (!right) 
				times = 4 - times;
				
			var result:Array = matrix;
			for (var i:int = 0; i < times; i++)
				result = rotateMatrixRight(result);
			
			return result;
		}
		
		static private function rotateMatrixRight(array2d:Array):Array
		{
			var height:int = array2d.length;
			var width:int = array2d[0].length;
			var result:Array = new Array(width);
			for (var i:int = 0; i < width; i++)
			{
				result[i] = new Array(height);
				for(var j:int = 0; j < height; j++)
					result[i][j] = array2d[height - 1 - j][i];
			}
			return result;
		}
		
	}

}