License
=======

Apache License 2.0


About
=====

This is a dart port of the [original java Universal Tween Engine][1] created by Aurelien Ribbon.
This readme is an adaptation of the original's engine readme and includes how things are handled in the dart version of the engine.

You can find a demo of the library [here][2].
The engine might have some bugs. Use at your own risk.

______


Introduction
============

The Universal Tween Engine enables the interpolation of every attribute from any object in any dart project (server or client side).
Tweens are 'fire and forget'.

Implement the TweenAccessor interface, register it to the engine, and animate anything you want! 

```dart
class MyAccessor implements TweenAccessor<MyClass>{
  static const Type1 = 1;
  
  int getValues(MyClass target, int tweenType, List<num> returnValues){
    if ( tweenType == MyAccessor.Type1 ){
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      return 2;
    }
    return 0;
  }

  void setValues(MyClass target, int tweenType, List<num> newValues){
    if ( tweenType == MyAccessor.Type1 ){
      target.x = newValues[0];
      target.y = newValues[1];
    }
  }
}

class MyClass{
  num x=0, y=0;
}

main(){
   Tween.registerAccessor(MyClass, new MyAccessor());
}

```

_For the tween to be completed, a continuous call to TweenManager.Update(delta) is needed.
The delta parameter represents the time elapsed in **milliseconds** since last call to TweenManager.update_.

An easy way to obtain the delta is the `window.animationFrame` method:

```dart

TweenManager myManager;
main(){
  ...
  myManager = new TweenManager();
  window.animationFrame.then(update);
}

num lastUpdate = 0;
update(num delta){
  num deltaTime = (delta - lastUpdate) / 1000;
  lastUpdate = delta;
  
  myManager.update(deltaTime);
  window.animationFrame.then(update);
}
```

Next, send your objects to another position (here x=20 and y=30), with a smooth elastic transition, during 1 second.

```dart
// Arguments are 
// 1. the target
// 2. the type of interpolation
// 3. the duration in seconds
// Additional methods specify the target values, and the easing function. 

main(){
  ...
  Tween.to(myClass, MyAccessor.Type1, 1.0)
    ..targetValues = [20, 30]
    ..easing = Elastic.INOUT;
  window.animationFrame.then(update);
}

```

Possibilities are:

```dart
Tween.to(...); // interpolates from the current values to the targets
Tween.from(...); // interpolates from the given values to the current ones
Tween.set(...); // apply the target values without animation (useful with a delay)
Tween.call(...); // calls a method (useful with a delay)
```

Current options are:

```dart
myTween.delay = 0.5;
myTween.repeat(2, 0.5);
myTween.repeatYoyo(2, 0.5);
myTween.pause();
myTween.resume();
myTween.setCallback(callback);
myTween.setCallbackTriggers(flags);
myTween.setUserData(obj);
```

You can of course chain everything (with dart's method cascading):

```dart
Tween.to(...)
 ..delay = 1
 ..repeat(2, 0.5)
 ..start(myManager);
```

By altering the delta parameter, adding slow-motion, fast-motion or reverse play is easy,
you just need to change the speed of the update:

```dart
myManager.update(delta * speed);
```

Create some powerful animation sequences!

```dart
Timeline.createSequence()
    // First, set all objects to their initial positions
    ..push(Tween.set(...))
    ..push(Tween.set(...))
    ..push(Tween.set(...))

    // Wait 1s
    ..pushPause(1.0)

    // Move the objects around, one after the other
    ..push(Tween.to(...))
    ..push(Tween.to(...))
    ..push(Tween.to(...))

    // Then, move the objects around at the same time
    ..beginParallel()
        ..push(Tween.to(...))
        ..push(Tween.to(...))
        ..push(Tween.to(...))
    ..end()

    // And repeat the whole sequence 2 times
    // with a 0.5s pause between each iteration
    ..repeatYoyo(2, 0.5)

    // Let's go!
    ..start(myManager);
```

You can also quickly create timers:

```dart
Tween.callBack(myCallback)
  ..delay(3000)
  ..start(myManager);
```


Main features
=============

- Supports every [interpolation function defined by Robert Penner](http://www.robertpenner.com/easing/).
- Can be used with any object. You just have to implement the `TweenAccessor` interface when you want interpolation capacities.
- Every attribute can be interpolated. The only requirement is that what you want to interpolate can be represented as a number.
- One line is sufficient to create and start a simple interpolation.
- Delays can be specified, to trigger the interpolation only after some time.
- Many callbacks can be specified (when tweens complete, start, end, etc.).
- Tweens and Timelines are pooled by default. If enabled, there won't be any object allocation during runtime!
- Tweens can be sequenced when used in Timelines.
- Tweens can act on more than one value at a time, so a single tween can change the whole position (X and Y) of a sprite for instance !
- Tweens and Timelines can be repeated, with a yoyo style option.
- Simple timers can be built with `Tween.callBack()`.
- Source code extensively documented!
- Test suite included!


Testing suite
=============

Since `0.10.0`, tweenengine has a (crude) test suite.
It leverages the `unittest` package.

To run it, you'll either need _Dartium_ or _dart2js_.

1. Browse `test/test.html` using Dartium.
2. Compile `test/test.dart` to `test/test.dart.js` using dart2js, and then browse `test/test.html`.



  [1]: https://code.google.com/p/java-universal-tween-engine/
  [2]: http://xaguzman.github.io/tween-engine-dart/