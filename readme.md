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
- Class-specific AND Instance-level dependency configuration
- Value mapping
- Reference mapping
- <b>Reference mapping by {expressions}</b>
- Singleton mapping
- Prototype mapping
- Interface mapping
- Abstract class mapping
- Factory method mapping
- Custom provider mapping
- <b>Pool mapping</b>
- Automatic dependency resolution for unmapped objects requested from an alchemist
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
