Orichalcum-Alchemy
==================
A Truly Magical IoC Container!
<br>

## Backgound

Originally created as an internal IoC solution for Orichalcum Studios.
<br>
This featured library is now available for the AS3 developer community under the [MIT License](https://github.com/LandonLunsford/Orichalcum-Alchemy/blob/master/license).
<br>

## Features
1.

## Distinguishing Features
1.

## Known Limitations and Gotchas
1. When using XML Configurations, make sure to include referenced classes so the flash compiler will include them in the swf! This can be done by one of two ways:
	1. Add an "import your.configuration.referenced.Class;" statement somewhere in your code.
	2. If your class is in a library you can use the "included library" option when compiling.
2. [WARNING] Constructor Injections + Circluar Dependencies == infinite loop! This can be easily resolved by using property injections and a post construct lifecycle hook.

## Coming Soon
1. User guide

## Getting Started
