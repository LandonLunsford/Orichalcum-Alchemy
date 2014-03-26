package orichalcum.alchemy.processor 
{
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.ingredient.EventHandler;
	import orichalcum.alchemy.ingredient.processor.EventHandlerProcessor;
	import orichalcum.alchemy.ingredient.processor.IIngredientProcessor;
	import orichalcum.alchemy.processor.target.AssumedTargetAndImplicitEventMediator;
	import orichalcum.alchemy.processor.target.ExplicitTargetAndEventMediator;
	import orichalcum.alchemy.processor.target.ExplicitTargetAndImplicitEventMediator;
	import orichalcum.alchemy.processor.target.ImplicitTargetAndEventMediator;
	import orichalcum.alchemy.processor.target.ImplicitTargetAndExplicitEventMediator;


	public class EventHandlerProcessorTest 
	{
		
		private var _processor:EventHandlerProcessor;
		private var _event:Event = new Event('event');
		private var _expectedEventType:String = 'event';
		private var _expectedTargetPath:String = 'target';
		private var _alchemist:IAlchemist;
		
		[Before]
		public function before():void
		{
			_processor = new EventHandlerProcessor;
		}
		
		private function introspect(type:Class):EventHandler
		{
			const recipe:Dictionary = new Dictionary;
			_processor.introspect(
				getQualifiedClassName(type),
				describeType(type),
				recipe,
				_alchemist
			);
			return recipe.eventHandlers[0] as EventHandler;
		}
		
		/**
		 * [EventHandler]
		 * public function [this_]event():void
		 */
		[Test]
		public function testIntrospectionOfAssumedTargetAndImplicitEvent():void
		{
			const handler:EventHandler = introspect(AssumedTargetAndImplicitEventMediator);
			//assertThat(handler.targetPath, equalTo('this'))
			// objects.find will return root object "this" if targetPath is null
			assertThat(handler.targetPath, equalTo(null)) 
			assertThat(handler.type, equalTo(_expectedEventType))
		}
		
		/**
		 * [EventHandler]
		 * public function target_event():void
		 */
		[Test]
		public function testIntrospectionOfImplicitTargetAndEvent():void
		{
			const handler:EventHandler = introspect(ImplicitTargetAndEventMediator);
			assertThat(handler.targetPath, equalTo(_expectedTargetPath))
			assertThat(handler.type, equalTo(_expectedEventType))
		}
		
		/**
		 * [EventHandler(target="target", event="event")]
		 * public function anyName():void
		 */
		[Test]
		public function testIntrospectionOfExplicitTargetAndEvent():void
		{
			const handler:EventHandler = introspect(ExplicitTargetAndEventMediator);
			assertThat(handler.targetPath, equalTo(_expectedTargetPath))
			assertThat(handler.type, equalTo(_expectedEventType))
		}
		
		/**
		 * [EventHandler(event="event")]
		 * public function target():void
		 * 
		 * Not technically possible because...
		 * 
		 * public var target:EventDispatcher; shares same name
		 */
		//[Test(expects="Exception")]
		public function testIntrospectionOfImplicitTargetAndExplicitEvent():void
		{
			introspect(ImplicitTargetAndExplicitEventMediator);
		}
		
		/**
		 * [EventHandler(target="target")]
		 * public function event():void
		 */
		[Test]
		public function testIntrospectionOfExplicitTargetAndImplicitEvent():void
		{
			const handler:EventHandler = introspect(ExplicitTargetAndImplicitEventMediator);
			assertThat(handler.targetPath, equalTo(_expectedTargetPath))
			assertThat(handler.type, equalTo(_expectedEventType))
		}
		
	}

}