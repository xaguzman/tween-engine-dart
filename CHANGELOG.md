#### V 0.11.0

* Fixed [issue #12](https://github.com/xaguzman/tween-engine-dart/issues/12) typo in tween.containsTarget which would make it missfunction

#### V 0.11.0

* Timeline.createSequence() and Timeline.createParallel() are now replaced for factory named constructors:
  * new Timeline.sequence()
  * new Timeline.parallel()=
* Tween.to, Tween.from, Tween.set, Tween.call and Tween.mark are now replaced for factory named constructors:
  * new Tween.to()
  * new Tweee.from()
  * new Tween.set()
  * new Tween.call()
  * new Tween.mark()
* TweenAccesor and Tweenable interfaces have both changed, now they both receive the tween as a paremeter in their getValues() and setValues() methods.
* BaseTween.normalTime added, provides the normalized elapsed time of the tween ( 0 <= normalTime <= 1)

#### V 0.10.2

* Fixed a bug where creating a new Tween from within a callback would break the TweenManager
* Methods setCallback, setCallbackTriggers and setUserData replaced by their respective setters
* repeatYoyo() will be deprecated in next version, instead, repeat() now takes a bool argument saying wether it is a yoyo repetition or not.
* Removed generic argument from BaseTween class


#### V 0.10.1

Bugs Fixed:
* Changed Timeline to not 'snap' when using a repeat yoyo on it. [issue #7](https://github.com/xaguzman/tween-engine-dart/issues/7)
* added Changelog
* changed CallbackHandler to TweenCallbackHandler
* Twee.setCallBack() now receives a TweenCallbackHandler(function) instead of a TweenCallback instance

#### V 0.10.0

* added tweenable interface
* added crude test suit
* loosened dart sdk dependency

### V 0.9.0

* first publish, contains all features of the [original java version](https://github.com/AurelienRibon/universal-tween-engine)