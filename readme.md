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
- <b>XML, Metatag and AS3 dependency configuration</b>
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

#### Differences
- No support for post-construct/pre-construct arguments (it is largely unnecessary and unused, and therefore it was dropped from the spec)
- No "optional" setting for metadata-configured injections (e.g. [Inject(optional)])
Give me one use case where a "dependency" is optional.
For the equivalent functionality please use the AS3 runtime dependency configuration API over the metatag API (e.g. map(id).to(something).add(optionalIngredient))

#### Installation
	alchemist = new Alchemist;

#### Conjure Unmapped Type
	const unmapped:UnmappedType = alchemist.conjure(UnmappedType) as UnmappedType;

#### Value Mapping
	alchemist.map('library.power.level').to(10000)

#### Reference Mapping
	alchemist.map('someId').to(reference('anotherId'))
	alchemist.map(SomeClass).to(reference('anotherId'))

#### Reference Mapping via Expression Language
	alchemist.map('someId').to('{anotherId}')

#### Singleton Mapping
	alchemist.map(God).to(singleton(God)) // well if you are Christian anyway

#### Prototype Mapping
	alchemist.map(Ant).to(prototype(Ant))
	alchemist.map(Ant).to(type(Ant))

#### Interface Mapping
	alchemist.map(IEventDispatcher).to(singleton(EventDispatcher))
	
#### Factory Method Mapping
	alchemist.map(Product).to(factory(Factory.create))
	alchemist.map(Product).to(factory(function():*{ return new Product; }))
	
#### Pool Mapping
	// Pools auto expand when more instances are conjured
	// and serve as a good way to reuse objects instead of newly instantiating
	// them every time which will trigger garbage collection cycles
	alchemist.map(Socket).to(pool(Socket))
	
	// Get an instance of socket from the pool
	const socket:Socket = alchemist.conjure(Socket) as Socket;
	
	// Return the socket instance to the pool
	alchemist.destroy(socket);
	
#### Custom Provider Mapping
	alchemist.map(Provision).to(new MyCustomProvider)

#### Custom Provider Mapping
	alchemist.map(Provision).to(new MyCustomProvider)

#### Side Notes
It is interesting to note that in Orichalcum alchemy
	alchemist.map(IEventDispatcher).to(singleton(EventDispatcher))
is the same as
	alchemist.map('flash.display::IEventDispatcher').to(singleton(EventDispatcher))

