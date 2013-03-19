package orichalcum.utility 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	
	/**
	 * @TODO change format of closure passing to (container, type, closure, args)... closure.apply(null, args.unshift(target));
	 * that way the 'this' inside the closure will be the 'target'
	 */
	
	public class DisplayObjectUtil
	{
		
		static public function isSibling(object:DisplayObject, sibling:DisplayObject):Boolean
		{
			if (!object.parent) return false;
			for (var i:int = object.parent.numChildren - 1; i >= 0; i--)
				if (object.parent.getChildAt(i) === sibling)
					return true;
			return false;
		}

		static public function isAncestor(object:DisplayObject, ancestor:DisplayObject):Boolean
		{
			throw new IllegalOperationError('DisplayObjectUtil.isAncenstor() is not implemented');
		}
		
		static public function isDecendant(object:DisplayObject, decendant:DisplayObject):Boolean
		{
			throw new IllegalOperationError('DisplayObjectUtil.isDecendant() is not implemented');
		}
		
		static public function depthOf(object:DisplayObject):int
		{
			if (!object) return 0;
			var depth:int;
			var parent:DisplayObjectContainer = object.parent;
			while (parent != null)
			{
				parent = parent.parent;
				depth++;
			}
			return depth;
		}
		
		static public function childrenOf(container:DisplayObjectContainer, type:Class = null):Array
		{
			if (!container) return null; // should be UnmodifiableEmptyArray
			var children:Array = [];
			var collector:Function = function(child:*):void { children.push(child); };
			eachChild(container, collector, type);
			return children;
		}
		
		static public function descendantsOf(container:DisplayObjectContainer, type:Class = null):Array
		{
			if (!container) return null; // should be UnmodifiableEmptyArray
			var decendants:Array = [];
			var collector:Function = function(child:*):void { decendants.push(child); };
			eachDecendant(container, collector, type);
			return decendants;
		}

		/**
		 * Room for optimization
		 * Applies Reverse order iteration
		 * @param	container
		 * @param	closure
		 * @param	type
		 */
		static public function eachChildReverse(container:DisplayObjectContainer, closure:Function, type:Class = null):void
		{
			var target:*;
			var child:DisplayObject;
			var childIndex:int = container.numChildren;
			
			while (--childIndex >= 0)
			{
				child = container.getChildAt(childIndex);
				
				if (type)
				{
					target = child as type;
					if (target) closure(target);
				}
				else
				{
					closure(child);
				}
				
				while (childIndex >= container.numChildren) childIndex--;
			}
		}
		
		static public function eachChild(container:DisplayObjectContainer, closure:Function, type:Class = null):void
		{
			var target:*;
			var child:DisplayObject;
			var childCount:int = container.numChildren;
			for (var childIndex:int = 0; childIndex < childCount; childIndex++)
			{
				child = container.getChildAt(childIndex);
				
				if (type)
				{
					target = child as type;
					if (target) closure(target);
				}
				else
				{
					closure(child);
				}
				
				if (childCount != container.numChildren)
					throw new Error('Child removed during iteration');
			}
		}

		/**
		 * Room for optimization
		 * Applies Depth First Reverse order iteration
		 * @param	container
		 * @param	closure
		 * @param	type
		 */
		static public function eachDecendant(container:DisplayObjectContainer, closure:Function, type:Class = null):void
		{
			var target:*;
			var child:DisplayObject;
			var next:DisplayObjectContainer;
			var childIndex:int = container.numChildren;
			
			while (--childIndex >= 0)
			{
				child = container.getChildAt(childIndex);
				next = child as DisplayObjectContainer;

				if (next) eachDecendant(next, closure, type);
				
				if (type)
				{
					target = child as type;
					if (target) closure(target);
				}
				else
				{
					closure(child);
				}
				
				while (childIndex >= container.numChildren) childIndex--;
			}
		}
	}

}