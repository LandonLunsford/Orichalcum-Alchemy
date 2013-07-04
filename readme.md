Orichalcum-Alchemy
==================

![ScreenShot](https://raw.github.com/LandonLunsford/Orichalcum-Alchemy/master/images/orichalchemy-pot.png)

<p>
Hi I'm Orichalcum Alchemy!
But you can call him Orichalchemy for short.
</p>
<p>
I am literally an IoC <i>container</i>!
Cheers!
</p>
## Backgound

Originally created as an internal IoC solution for jaredlunsford.com.
<br>
This featured library is now available for the AS3 developer community under the [MIT License](https://github.com/LandonLunsford/Orichalcum-Alchemy/blob/master/license).
<br>

## Features
- XML, Metatag and AS3 dependency configuration*
- Dependency mapping inheritance model*
- Class-specific or Instance-level dependency configuration
- Value mapping
- Reference mapping
- Singleton mapping
- Prototype mapping
- Interface mapping
- Abstract class mapping
- Factory method mapping
- Custom provider mapping
- Pool mapping*
- Automatic dependency resolution for unmapped objects requested from an alchemist
- Simple and clean API*

*= distinguishing features


## Known Limitations and Gotchas

1. Constructor Injections + Circluar Dependencies == infinite loop! This can be easily resolved by using property injections and a post construct lifecycle hook.
2. When using XML configuration, make sure to include referenced classes so the flash compiler will include them in the swf! This can be done by one of two ways:
	1. Add an "import your.configuration.referenced.Class;" statement somewhere in your code.
	2. If your class is in a library you can use the "included library" option when compiling.


## Coming Soon
1. User guide
2. ASDocs
3. Even more test coverage!
4. Performance tests against other leading AS3 IoC solutions like SwiftSuspenders and Swiz!

## Getting Started

### Differences
- No support for post-construct/pre-construct arguments (it is largely unnecessary and unused, and therefore it was dropped from the spec)
- No "optional" setting for metadata-configured injections (e.g. [Inject(optional)])
Give me one use case where a "dependency" is optional.
For identical functionality please use the AS3 dependency configuration API over the metatag API
