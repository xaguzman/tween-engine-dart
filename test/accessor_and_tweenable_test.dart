import 'dart:async';
import 'package:test/test.dart';
import 'package:tweenengine/tweenengine.dart';

/// Fixture [TweenAccessor] for tests
class MyAccessor implements TweenAccessor<MyClass> {
  static const xy = 1;

  int getValues(
      MyClass target, Tween tween, int tweenType, List<num> returnValues) {
    if (tweenType == MyAccessor.xy) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      return 2;
    }
    return 0;
  }

  void setValues(
      MyClass target, Tween tween, int tweenType, List<num> newValues) {
    if (tweenType == MyAccessor.xy) {
      target.x = newValues[0];
      target.y = newValues[1];
    }
  }
}

/// Fixture class for tests (/!\ MUST HAVE VALUES)
class MyClass {
  num x = 0, y = 0;
  int n = 0;
}

/// Test fixture object with tweenable properties
class MyTweenable implements Tweenable {
  static const int typeAnswer = 1;
  static const int typeCircle = 2;

  num answer = 42;
  num circle = 6.2831853;

  int getTweenableValues(Tween tween, int tweenType, List<num> returnValues) {
    if (tweenType == typeAnswer) {
      returnValues[0] = answer;
    } else if (tweenType == typeCircle) {
      returnValues[0] = circle;
    }
    return 1;
  }

  void setTweenableValues(Tween tween, int tweenType, List<num> newValues) {
    if (tweenType == typeAnswer) {
      answer = newValues[0];
    } else if (tweenType == typeCircle) {
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
  TweenManager myManager;
  Stopwatch watch;
  Timer timer;
  Tween.registerAccessor(MyClass, MyAccessor());

  setUp(() {
    myManager = TweenManager();
    watch = Stopwatch();

    var ticker = (timer) {
      var deltaInSeconds = watch.elapsedMilliseconds / 1000;

      myManager.update(deltaInSeconds);
      watch.reset();
    };

    var duration = Duration(milliseconds: 1000 ~/ 60);
    watch.start();
    timer = Timer.periodic(duration, ticker);
  });

  tearDown(() {
    timer.cancel();
    watch.stop();
  });

  // TEST
  group('Tween accessor', () {
    test('Simple Tween', () {
      var myClass = MyClass();

      // The following are expected to be called exactly once
      Function expectOnBegin = expectAsync1((tween) {});
      Function expectOnComplete = expectAsync1((tween) {});
      Function expectOnStart = expectAsync1((tween) {});
      Function expectOnEnd = expectAsync1((tween) {});

      TweenCallbackHandler myCallback = (type, tween) {
        switch (type) {
          case TweenCallback.begin:
            expectOnBegin(tween);
            break;
          case TweenCallback.complete:
            expectOnComplete(tween);
            expect(myClass.x, equals(20));
            expect(myClass.y, equals(30));
            break;
          case TweenCallback.start:
            expectOnStart(tween);
            break;
          case TweenCallback.end:
            expectOnEnd(tween);
            break;
          default:
            print('DEFAULT CALLBACK CAUGHT ; type = ' + type.toString());
        }
      };

      Tween.to(myClass, MyAccessor.xy, 0.5)
        ..targetValues = [20, 30]
        ..easing = Elastic.INOUT
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.any
        ..start(myManager);
    });
  });

  group('Tweenable', () {
    test('Simple Tween', () {
      var life = MyTweenable();

      Function expectOnBegin = expectAsync1((tween) {});
      Function expectOnComplete = expectAsync1((tween) {});
      Function expectOnStart = expectAsync1((tween) {});
      Function expectOnEnd = expectAsync1((tween) {});

      TweenCallbackHandler myCallback = (type, tween) {
        switch (type) {
          case TweenCallback.begin:
            expectOnBegin(tween);
            break;
          case TweenCallback.complete:
            expectOnComplete(tween);
            expect(life.answer, equals(69));
            break;
          case TweenCallback.start:
            expectOnStart(tween);
            break;
          case TweenCallback.end:
            expectOnEnd(tween);
            break;
          default:
            print('DEFAULT CALLBACK CAUGHT ; type = ' + type.toString());
        }
      };

      // Sanity checks
      expect(life.answer, equals(42));

      // Tween the answer
      Tween.to(life, MyTweenable.typeAnswer, 0.5)
        ..targetValues = [69]
        ..easing = Linear.INOUT
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.any
        ..start(myManager);
    });
  });
}
