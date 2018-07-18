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
    if (tween.userData is String) {
      if (tween.userData == 'time') {
        print('local: ${tween.currentTime}');
        print('normal local: ${tween.normalTime}');
      }
    }

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

  group('Normalized time', () {
    test('Tween.to', () {
      var myClass = MyClass();

      // start / begin
      Function expectOnBegin = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(0));
      }, count: 2);

      // end / complete
      Function expectOnComplete = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(1));
      }, count: 2);

      TweenCallbackHandler callback = (int type, BaseTween tween) {
        if (type == TweenCallback.begin || type == TweenCallback.start)
          expectOnBegin(tween);
        else if (type == TweenCallback.complete || type == TweenCallback.end)
          expectOnComplete(tween);
      };

      Tween.to(myClass, 1, 0.25)
        ..targetValues = [20, 20]
        ..callback = callback
        ..callbackTriggers = TweenCallback.any
        ..userData = 'time'
        ..start(myManager);
    });

    test('Tween.from', () {
      var myClass = MyClass();

      // start / begin
      Function expectOnBegin = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(0));
      }, count: 2);

      // end / complete
      Function expectOnComplete = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(1));
      }, count: 2);

      TweenCallbackHandler callback = (int type, BaseTween tween) {
        if (type == TweenCallback.begin || type == TweenCallback.start)
          expectOnBegin(tween);
        else if (type == TweenCallback.complete || type == TweenCallback.end)
          expectOnComplete(tween);
      };

      Tween.from(myClass, 1, 0.25)
        ..targetValues = [20, 20]
        ..callback = callback
        ..callbackTriggers = TweenCallback.any
        ..userData = 'time'
        ..start(myManager);
    });

    test('repeat', () {
      var myClass = MyClass();

      Function expectOnBegin = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(0));
      });

      Function expectOnStart = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, lessThan(1));
      }, count: 2);

      Function expectOnEnd = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, greaterThan(0));
      }, count: 2);

      Function expectOnComplete = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(1));
      });

      TweenCallbackHandler myCallback = (type, tween) {
        switch (type) {
          case TweenCallback.begin:
            expectOnBegin(tween);
            break;
          case TweenCallback.complete:
            expectOnComplete(tween);
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

      Tween.to(myClass, 1, 0.25)
        ..targetValues = [20, 20]
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.any
        ..repeat(1, 0)
        ..userData = 'time'
        ..start(myManager);
    });

    test('repeat yoyo', () {
      var myClass = MyClass();

      Function expectOnBegin = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(0));
      });

      Function expectOnStart = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, lessThan(1));
      }, count: 2);

      Function expectOnEnd = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, greaterThan(0));
      }, count: 2);

      Function expectOnComplete = expectAsync1((BaseTween tween) {
        expect(tween.normalTime, equals(1));
      });

      TweenCallbackHandler myCallback = (type, tween) {
        switch (type) {
          case TweenCallback.begin:
            expectOnBegin(tween);
            break;
          case TweenCallback.complete:
            expectOnComplete(tween);
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

      Tween.to(myClass, 1, 0.25)
        ..targetValues = [20, 20]
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.any
        ..repeatYoyo(1, 0)
        ..userData = 'time'
        ..start(myManager);
    });
  });
}
