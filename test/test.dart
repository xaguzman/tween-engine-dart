import 'dart:html';
import 'dart:isolate';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'package:tweenengine/tweenengine.dart';

/// Fixture [TweenAccessor] for tests
class MyAccessor implements TweenAccessor<MyClass> {
  static const XY = 1;

  int getValues(MyClass target, int tweenType, List<num> returnValues) {
    if (tweenType == MyAccessor.XY) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      return 2;
    }
    return 0;
  }

  void setValues(MyClass target, int tweenType, List<num> newValues) {
    if (tweenType == MyAccessor.XY) {
      target.x = newValues[0];
      target.y = newValues[1];
    }
  }
}

/// Fixture class for tests (/!\ MUST HAVE VALUES)
class MyClass {
  num x=0, y=0;
  int n=0;
}

/// Test fixture object with tweenable properties
class MyTweenable {
  int answer = 42;
  num circle = 6.2831853;
}

main() {

  // SETUP TEST SUITE

  useHtmlEnhancedConfiguration();
  unittestConfiguration.timeout = new Duration(seconds: 3);

  // SETUP TWEEN ENGINE

  TweenManager myManager = new TweenManager();

  num lastUpdate;
  update(num timestampInMs){

    num deltaInSeconds;
    // Edge-case when a tween starts with the very first update
    if (lastUpdate == null) {
      deltaInSeconds = 0;
    } else {
      deltaInSeconds = (timestampInMs - lastUpdate) / 1000;
    }

    lastUpdate = timestampInMs;

    myManager.update(deltaInSeconds);
    window.animationFrame.then(update);
  }

  window.animationFrame.then(update);

  // TEST

  group('Using TweenAccessor', () {

    test('it basically works', () {

      // This is a very crude test, not covering much of the code base
      // Some ideas of tests :
      // - backward events
      // - meaningful exceptions :
      //   - myClass with null properties
      //   - myClass with non-numeric properties

      Tween.registerAccessor(MyClass, new MyAccessor());

      // The following are expected to be called exactly once
      Function expectOnBegin     = expectAsync1((tween){});
      Function expectOnComplete  = expectAsync1((tween){});
      Function expectOnStart     = expectAsync1((tween){});
      Function expectOnEnd       = expectAsync1((tween){});

      TweenCallback myCallback = new TweenCallback();
      myCallback.onEvent = (type, tween) {
        switch(type) {
          case TweenCallback.BEGIN:
            print('BEGIN');
            expectOnBegin(tween);
            break;
          case TweenCallback.COMPLETE:
            print('COMPLETE');
            expectOnComplete(tween);
            break;
          case TweenCallback.START:
            print('START');
            expectOnStart(tween);
            break;
          case TweenCallback.END:
            print('END');
            expectOnEnd(tween);
            break;
          default:
            print('DEFAULT ' + type.toString());
        }
      };

      var myClass = new MyClass();
      Tween.to(myClass, MyAccessor.XY, 1.0)
        ..targetValues = [20, 30]
        ..easing = Elastic.INOUT
        ..setCallback(myCallback)
        ..setCallbackTriggers(TweenCallback.ANY)
        ..start(myManager);
    });

  });

}