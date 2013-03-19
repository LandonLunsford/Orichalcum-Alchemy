package orichalcum.utility 
{
	import flash.display.DisplayObjectContainer;
	
	public class ObjectUtil
	{
		static public function isEmpty(object:Object):Boolean
		{
			if (object)
				for (var property:String in object)
					return true;
			return false;
		}
		
		static public function extend(a:Object, b:Object):Object
		{
			for (var property:String in b)
				a[property] = b[property];
			return a;
		}
		
		static public function find(targetRoot:Object, targetPath:String, pathDelimiter:String = '.'):*
		{
			var target:* = targetRoot, nextTargetName:String, previousPeriodIndex:int, nextPeriodIndex:int;
			while (true)
			{
				nextPeriodIndex = targetPath.indexOf(pathDelimiter, previousPeriodIndex);
				if (nextPeriodIndex < 0)
				{
					nextTargetName = targetPath.substring(previousPeriodIndex);
					if (nextTargetName in target)
					{
						return target[nextTargetName];
					}
					if (target is DisplayObjectContainer)
					{
						return target.getChildByName(nextTargetName);
					}
					throw new ArgumentError(StringUtil.substitute('Variable or child named "{0}" could not be found on "{1}". Check to make sure that it is public and named correctly.', targetPath, targetRoot));
				}
				
				nextTargetName = targetPath.substring(previousPeriodIndex, nextPeriodIndex)
				if (nextTargetName in target)
				{
					target = target[nextTargetName];
				}
				else if (target is DisplayObjectContainer)
				{
					target = target.getChildByName(nextTargetName);
				}
				else
				{
					throw new ArgumentError(StringUtil.substitute('Variable or child named "{0}" could not be found on "{1}". Check to make sure that it is public and named correctly.', targetPath, targetRoot));
				}
				previousPeriodIndex = nextPeriodIndex + 1;
			}
			return target;
		}
		
		/**
		 * @param	child Object to which the parents attributes will be given
		 * @param	parent Object from which the child will inherit attributes
		 * @return	the modified child object
		 */
		static public function merge(child:Object, parent:Object):Object
		{
			var attribute:String;
			if (isDynamic(child))
			{
				for (attribute in parent)
					if (child[attribute] == undefined)
						child[attribute] = parent[attribute];
			}
			else
			{
				for (attribute in parent)
					if (attribute in child && child[attribute] == undefined)
						child[attribute] = parent[attribute];
			}
			return child;
		}
		
		/**
		 * @param	child Object to which the parents attributes will be given
		 * @param	parent Object from which the child will inherit attributes
		 * @return	the modified child object
		 */
		static public function inherit(child:Object, parent:Object):Object
		{
			var attribute:String;
			if (isDynamic(child))
			{
				for (attribute in parent)
					child[attribute] = parent[attribute];
			}
			else
			{
				for (attribute in parent)
					if (attribute in child)
						child[attribute] = parent[attribute];
			}
			return child;
		}
		
		
		static public function swap(object1:Object, object2:Object):Object
		{
			/**
			 * If proxy is not used the properties of object1 will be iterated over twice
			 * this is due to the set operation of the property
			 */
			const proxy:Object = clone(object1);
			for (var property:String in proxy)
			{
				if (property in object2)
				{
					var temp:* = object1[property];
					object1[property] = object2[property];
					object2[property] = temp;
				}
			}
			return object1;
		}
		
		/**
		 * @param	object The target for property removal
		 * @return	object The modified object
		 */
		static public function empty(object:Object):Object
		{
			for (var property:String in object)
				delete object[property];
			return object;
		}
		
		/**
		 * @param	object The target for reference removal
		 * @return	object The modified object
		 */
		static public function clean(object:Object):Object
		{
			for (var property:String in object)
				object[property] = undefined;
			return object;
		}
		
		/**
		 * @param	object The target to test
		 * @return	true if object is an instance of a dynamic class
		 */
		static public function isDynamic(object:Object):Boolean
		{
			try
			{
				object.__;
			}
			catch (error:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * Creates a new object of the specified class
		 * @param	type Class to be instantiated
		 * @param	parameters Dependencies to passed into the objects constructor
		 * @param	properties Map of properties and values which will be set in the new object
		 * @return	New object of indicated type
		 */
		static public function create(type:Class, args:Array = null):Object
		{
			if (!type) throw new ArgumentError('Parameter "type" must not be null');
			
			if (args)
			{
				switch(args.length)
				{
					case 1:	return new type(args[0]);
					case 2: return new type(args[0], args[1]);
					case 3: return new type(args[0], args[1], args[2]);
					case 4: return new type(args[0], args[1], args[2], args[3]);
					case 5: return new type(args[0], args[1], args[2], args[3], args[4]);
					case 6: return new type(args[0], args[1], args[2], args[3], args[4], args[5]);
					case 7: return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					case 8: return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					case 9:	return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					case 10:return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					throw new ArgumentError('too many arguments. refactor!');
				}
			}
			return new type();
		}
		
		static public function clone(object:Object):Object
		{
			const clone:Object = {};
			for (var propertyName:String in object)
				clone[propertyName] = object[propertyName];
			return clone;
		}
		
		/**
		 * Sets the object's properties to the corresponding value found in the properties param
		 * @param	object The object whose properties will be modified
		 * @param	properties The property:value map used whose values are placed in the object
		 * @return	The param 'object' whose properties were modified
		 */
		static public function initialize(object:Object, properties:Object):Object
		{
			if (isDynamic(object))
			{
				for (var property:String in properties)
				{
					object[property] = properties[property];
				}
			}
			else
			{
				for (property in properties)
				{
					if (property in object)
					{
						object[property] = properties[property];
					}
				}
			}
			
			return object;
		}
		
	}

}
