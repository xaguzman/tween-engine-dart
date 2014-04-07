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
class MyTweenable implements Tweenable {
  static const int ANSWER = 1;
  static const int CIRCLE = 2;

  num answer = 42;
  num circle = 6.2831853;

  int getTweenableValues(int tweenType, List<num> returnValues) {
    if (tweenType == ANSWER) {
      returnValues[0] = answer;
    } else if (tweenType == CIRCLE) {
      returnValues[0] = circle;
    }
    return 1;
  }

  void setTweenableValues(int tweenType, List<num> newValues) {
    if (tweenType == ANSWER) {
      answer = newValues[0];
    } else if (tweenType == CIRCLE) {
      circle = newValues[0];
    }
  }
}


// This is a very crude test suite, not covering much of the code base.
// Some ideas of tests :
// - backward events
// - meaningful exceptions :
//   - myClass with null properties
//   - myClass with non-numeric properties



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

      var myClass = new MyClass();

      // Register the accessor
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
            expectOnBegin(tween);
            break;
          case TweenCallback.COMPLETE:
            expectOnComplete(tween);
            break;
          case TweenCallback.START:
            expectOnStart(tween);
            break;
          case TweenCallback.END:
            expectOnEnd(tween);
            break;
          default:
            print('DEFAULT CALLBACK CAUGHT ; type = ' + type.toString());
        }
      };

      Tween.to(myClass, MyAccessor.XY, 0.1)
        ..targetValues = [20, 30]
        ..easing = Elastic.INOUT
        ..setCallback(myCallback)
        ..setCallbackTriggers(TweenCallback.ANY)
        ..start(myManager);
    });

  });

  group('Using Tweenable', () {

    test('it basically works', () {

      var life = new MyTweenable();

      // The following are expected to be called exactly once
      // Note that `expectAsync1` will soon be deprecated.
      Function expectOnBegin     = expectAsync1((tween){});
      Function expectOnComplete  = expectAsync1((tween){});
      Function expectOnStart     = expectAsync1((tween){});
      Function expectOnEnd       = expectAsync1((tween){});

      TweenCallback myCallback = new TweenCallback();
      myCallback.onEvent = (type, tween) {
        switch(type) {
          case TweenCallback.BEGIN:
            expectOnBegin(tween);
            break;
          case TweenCallback.COMPLETE:
            expectOnComplete(tween);
            expect(life.answer, equals(69));
            break;
          case TweenCallback.START:
            expectOnStart(tween);
            break;
          case TweenCallback.END:
            expectOnEnd(tween);
            break;
          default:
            print('DEFAULT CALLBACK CAUGHT ; type = ' + type.toString());
        }
      };

      // Sanity checks
      expect(life.answer, equals(42));

      // Tween the answer
      Tween.to(life, MyTweenable.ANSWER, 0.1)
        ..targetValues = [69]
        ..easing = Linear.INOUT
        ..setCallback(myCallback)
        ..setCallbackTriggers(TweenCallback.ANY)
        ..start(myManager);
    });

  });

}