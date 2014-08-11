#### V 0.10.2

* Fixed a bug where creating a new Tween from within a callback would break the TweenManager

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