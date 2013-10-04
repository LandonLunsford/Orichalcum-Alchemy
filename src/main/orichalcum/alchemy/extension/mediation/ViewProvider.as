package orichalcum.alchemy.extension.mediation 
{
	import avmplus.getQualifiedClassName;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.provider.IProvider;
	import orichalcum.alchemy.recipe.Recipe;
	import orichalcum.lifecycle.IDisposable;
	
	
		// still wont work 
		// will only work with singleton view and mediators
		// cuz mediator will need to know the correct view...
		// will work with IMediator
		//onRegister(view)
		//onUnregister(view) with added to stage events being forwarded
		// next step! make sure provide passes type/id key!!! for hooking!!
	/**
	 * Ideally I could add a filter directly into the alchemist's create() lifecyle chain
	 */
	public class ViewProvider implements IProvider, IDisposable
	{
		
		private var _context:IAlchemist;
		
		/**
		 * Mediator class by view class
		 */
		private var _mediators:Dictionary;
		
		/**
		 * Mediator instance by view instance class
		 */
		private var _activeMediatorsByView:Dictionary;
		
		
		public function ViewProvider(context:IAlchemist, mediators:Dictionary) 
		{
			_context = context;
			_mediators = mediators;
			_activeMediatorsByView = new Dictionary;
		}
		
		public function dispose():void 
		{
			_context = null;
			_mediators = null;
			for (var view:* in _activeMediatorsByView)
			{
				_context.destroy(view);
				_context.destroy(_activeMediatorsByView[view]);
			}
			_activeMediatorsByView = null;
		}
		
		
		public function provide(viewInstanceIdOrClass:*, context:IAlchemist, recipe:Recipe):*
		{
			//const view:DisplayObject = 
			//trace('wut is it?',_context.conjure(
				//viewInstanceIdOrClass is Class
					//? viewInstanceIdOrClass
					//: ApplicationDomain.currentDomain.getDefinition(trace(getQualifiedClassName(viewInstanceIdOrClass))) as Class)
					//);
			
			const view:DisplayObject = _context.conjure(viewInstanceIdOrClass) as DisplayObject;
					
			view.addEventListener(Event.ADDED_TO_STAGE, view_onAddedToStage);
			return view;
		}
		
		public function destroy(provision:*):* 
		{
			const view:DisplayObject = provision as DisplayObject;
			view.hasEventListener(Event.ADDED_TO_STAGE) && view.removeEventListener(Event.ADDED_TO_STAGE, view_onAddedToStage);
			view.hasEventListener(Event.REMOVED_FROM_STAGE) && view.removeEventListener(Event.REMOVED_FROM_STAGE, view_onRemovedFromStage);
			_deactivateMediatorFor(view);
			_context.destroy(view);
		}
		
		
		private function view_onAddedToStage(event:Event):void 
		{
			const view:DisplayObject = event.target as DisplayObject;
			view.removeEventListener(Event.ADDED_TO_STAGE, view_onAddedToStage);
			view.addEventListener(Event.REMOVED_FROM_STAGE, view_onRemovedFromStage);
			_hasActiveMediator(view) || _activateMediatorFor(view);
		}
		
		private function view_onRemovedFromStage(event:Event):void 
		{
			const view:DisplayObject = event.target as DisplayObject;
			view.removeEventListener(Event.REMOVED_FROM_STAGE, view_onRemovedFromStage);
			view.addEventListener(Event.ADDED_TO_STAGE, view_onAddedToStage);
			_deactivateMediatorFor(view);
		}
		
		private function _getMediatorFor(view:*):*
		{
			const viewClass:Class = ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(view)) as Class;
			const mediatorClass:Class = _mediators[viewClass];
			return mediatorClass ? _context.conjure(mediatorClass) : null;
		}
		
		private function _hasActiveMediator(view:DisplayObject):Boolean 
		{
			return _activeMediatorsByView[view] != null;
		}
		
		private function _activateMediatorFor(view:DisplayObject):void 
		{
			const mediator:IMediator = _getMediatorFor(view);
			if (mediator)
			{
				_activeMediatorsByView[view] = mediator;
				mediator.onActivate(view);
			}
		}
		
		private function _deactivateMediatorFor(view:DisplayObject):void 
		{
			const mediator:IMediator = _activeMediatorsByView[view];
			if (mediator)
			{
				mediator.onDeactivate(view);
				_context.destroy(mediator);
				delete _activeMediatorsByView[view];
			}
		}
		
	}

}