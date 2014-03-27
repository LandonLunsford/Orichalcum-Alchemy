Orichalcum-Alchemy
==================

![ScreenShot](https://raw.github.com/LandonLunsford/Orichalcum-Alchemy/master/images/orichalchemy-pot.png)

<p>
Hi I'm Orichalcum Alchemy!
But you can call me Orichalchemy for short.
</p>
<p>
I am literally an IoC Container!
<i>HAR HAR</i>
</p>
## Backgound

Originally created as an internal IoC solution for jaredlunsford.com.
<br>
This featured library is now available for the AS3 developer community under the [MIT License](https://github.com/LandonLunsford/Orichalcum-Alchemy/blob/master/license).
<br>

## Features
- <b>Metadata and AS3 dependency configuration</b>
- <b>Dependency mapping inheritance model</b>
- <b>Class-specific AND Instance-level dependency configuration</b>
- Value mapping
- Reference mapping
- <b>Reference mapping by {expressions}</b>
- Singleton mapping
- Prototype mapping
- Interface mapping
- Abstract class mapping (just because you can doesnt mean you should in this case)
- Factory method mapping
- <b>Pool mapping</b>
- <b>Custom provider mapping</b>
- <b>Automatic dependency resolution for unmapped objects requested from an alchemist</b>
- <b>Simple and fluent API</b>
- <b>Ability to easily create custom metadata/ingredient processor and dependency resolution plugins</b>

## Known Limitations and Gotchas

1. Constructor Injections + Circluar Dependencies == infinite loop! This can be easily resolved by using property injections and the post construct lifecycle hook.
2. When using XML configuration, make sure to include referenced classes so the flash compiler will include them in the swf! This can be done by one of two ways:
	1. Add an "import your.configuration.referenced.Class;" statement somewhere in your code.
	2. If your class is in a library you can use the "included library" option when compiling.

## Coming Soon
1. User guide
2. Improved ASDocs
3. Even more test coverage!
4. Performance tests against other leading AS3 IoC solutions like SwiftSuspenders, Swiz and Parsley!

## Getting Started

### Differences
- No support for post-construct/pre-construct arguments (it is largely unnecessary and unused, and therefore it was dropped from the spec)
- No "optional" setting for metadata-configured injections (e.g. [Inject(optional)])
Give me one use case where a "dependency" is optional.
For the equivalent functionality please use the AS3 runtime dependency configuration API over the metatag API (e.g. map(id).to(something).add(optionalIngredient))

### Installation
```actionscript
alchemist = new Alchemist;
```
### Runtime Mapping API

#### Value Mapping
```actionscript
alchemist.map('library.power.level').to(10000)
```
#### Reference Mapping
```actionscript
alchemist.map('someId').to(reference('anotherId'))
alchemist.map(SomeClass).to(reference('anotherId'))
```
#### Reference Mapping via Expression Language
```actionscript
alchemist.map('someId').to('{anotherId}')
```
#### Singleton Mapping
```actionscript
alchemist.map(God).to(singleton(God)) // well for Christian programs anyway
```
#### Prototype Mapping
```actionscript
alchemist.map(Ant).to(prototype(Ant))
alchemist.map(Ant).to(type(Ant))
```
#### Interface Mapping
```actionscript
alchemist.map(IEventDispatcher).to(singleton(EventDispatcher))
```	
#### Factory Method Mapping
```actionscript
alchemist.map(Product).to(factory(Factory.create))
alchemist.map(Product).to(factory(function():*{ return new Product; }))
```	
#### Pool Mapping
```actionscript
// Pools auto expand when more instances are conjured
// and serve as a good way to reuse objects instead of newly instantiating
// them every time which will trigger garbage collection cycles
alchemist.map(Socket).to(pool(Socket))

// Get an instance of socket from the pool
const socket:Socket = alchemist.conjure(Socket) as Socket;

// Return the socket instance to the pool
alchemist.destroy(socket);
```
#### Custom Provider Mapping
```actionscript
alchemist.map(Provision).to(new MyCustomProvider)
```
#### Constructor Argument Mapping
```actionscript
alchemist.map(Point).to(type(Point))
	.add(constructorArguments(100, 200))
	
alchemist.map(Point).to(type(Point))
	.add(constructorArgument(100))
	.add(constructorArgument(200))
```		
#### Property (public field/setter) Mapping
```actionscript
alchemist.map(Point).to(type(Point))
	.add(properties({
		x: 100,
		y: 200
	}))

alchemist.map(Point).to(type(Point))
	.add(property('x', 100))
	.add(property('y', 200))
```	
#### PostConstruct Mapping
```actionscript
alchemist.map(Matrix).to(new Matrix(2, 0, 0, 1))
	.add(postConstruct('invert'))
```		
#### PreDestroy Mapping
```actionscript
alchemist.map(BitmapData).to(type(BitmapData))
	.add(preDestroy('dispose'))
```		
### Metadata Mapping API
#### Property injetion by type
```actionscript
public class PropertyInjected
{
	[Inject]
	public var publicVariable:PublicVariableType;
	
	/**
	 * Cannot inject private, protected or internal variables.
	 * So inject the exposed setter instead.
	 */
	private var _privateVariable:SetterVariableType;
	
	[Inject]
	public function set setterVariable(value:SetterVariableType):void
	{
		_privateVariable = value;
	}
}
```
#### Property injetion by name
```actionscript
public class PropertyInjected
{

	/**
	 * This is supported but generally I try to avoid this because it is an
	 * example of "reaching out" which is the opposite of inversion of control
	 * To work around this I suggest using the Runtime mapping API likeso:
	 * alchemist.map(PropertyInjected)
	 *	.to(type(PropertyInjected))
	 *	.add(properties({publicVariable: someValueOrProvider}));
	 */
	[Inject("dependencyId")]
	public var publicVariable:*;
	
}
```
#### Event Handlers
Name your event handlers by the target_eventName convention and BAM!
The listener is added on creation and removed on destruction for you!
Or use any combination of the advanced options!
```actionscript
public class Mediator
{
	[Inject]
	public var view:View;
	
	[EventHandler]
	public function view_click(event:Event):void
	{
		trace('The view was clicked!');
	}
	
	[EventHandler(
		// listen for the event on the injected view object
		target="view",
		// listen for the MouseEvent.MOUSE_DOWN event
		event="mouseDown",
		// extract the mouseX,Y from the event object
		params="mouseX,mouseY",
		// stop bubbling and other listeners with same priority
		stopImmediatePropagation,
		// stop bubbling
		stopPropagation,
		// use the capture phase
		useCapture,
		// assign a priority
		priority="1",
		// remove the listener after the first trigger
		once		
	)]
	public function onViewMouseDown(mouseX:Number, mouseY:Number):void {}
}
```
#### Signal Handlers
```actionscript
public class Mediator
{
	[Inject]
	public var view:View;
	
	[SignalHandler]
	public function view_added():void {}
	
	[SignalHandler(signal="view.clicked", once)]
	public function onViewClicked():void {}
}
```
### Conjuring

#### Conjure Unmapped Type
```actionscript
const unmapped:UnmappedType = alchemist.conjure(UnmappedType) as UnmappedType;
```
#### Side Notes
It is interesting to note that the following two mappings are identical to the alchemist
```actionscript
alchemist.map(IEventDispatcher).to(singleton(EventDispatcher))
alchemist.map('flash.display::IEventDispatcher').to(singleton(EventDispatcher))
```
