
import 'dart:async';
import 'package:test/test.dart';
import 'package:tweenengine/tweenengine.dart';

/// Fixture [TweenAccessor] for tests
class MyAccessor implements TweenAccessor<MyClass> {
  static const XY = 1;

  int getValues(MyClass target, Tween tween, int tweenType, List<num> returnValues) {
    if (tweenType == MyAccessor.XY) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      return 2;
    }
    return 0;
  }

  void setValues(MyClass target, Tween tween, int tweenType, List<num> newValues) {    
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

  int getTweenableValues(Tween tween, int tweenType, List<num> returnValues) {
    if (tweenType == ANSWER) {
      returnValues[0] = answer;
    } else if (tweenType == CIRCLE) {
      returnValues[0] = circle;
    }
    return 1;
  }

  void setTweenableValues(Tween tween, int tweenType, List<num> newValues) {
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

  TweenManager myManager;
  Stopwatch watch;
  Timer timer;
  Tween.registerAccessor(MyClass, new MyAccessor());

  setUp( () {
    myManager = new TweenManager();
    watch = new Stopwatch();

    var ticker = (timer){
      var deltaInSeconds = watch.elapsedMilliseconds / 1000;

      myManager.update(deltaInSeconds);
      watch.reset();
    };

    var duration = new Duration(milliseconds: 1000 ~/ 60);
    watch.start();
    timer = new Timer.periodic(duration, ticker );
  });

  tearDown( (){
    timer.cancel();
    watch.stop();
  });

  // TEST
  group('Tween accessor', () {
    test('Simple Tween', () {
      var myClass = new MyClass();

      // The following are expected to be called exactly once
      Function expectOnBegin     = expectAsync((tween) {} );
      Function expectOnComplete  = expectAsync((tween) {});
      Function expectOnStart     = expectAsync((tween) {});
      Function expectOnEnd       = expectAsync((tween) {});

      TweenCallbackHandler myCallback = (type, tween) {
        switch(type) {
          case TweenCallback.BEGIN:
            expectOnBegin(tween);
            break;
          case TweenCallback.COMPLETE:
            expectOnComplete(tween);
            expect(myClass.x, equals(20));
            expect(myClass.y, equals(30));
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

      new Tween.to(myClass, MyAccessor.XY, 0.5)
        ..targetValues = [20, 30]
        ..easing = Elastic.INOUT
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.ANY
        ..start(myManager);
    });
  });

  
  group('Tweenable', () {
    test('Simple Tween', () {
      var life = new MyTweenable();

      Function expectOnBegin     = expectAsync((tween) {} );
      Function expectOnComplete  = expectAsync((tween) {} );
      Function expectOnStart     = expectAsync((tween) {} );
      Function expectOnEnd       = expectAsync((tween) {});

      TweenCallbackHandler myCallback = (type, tween) {
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
      new Tween.to(life, MyTweenable.ANSWER, 0.5)
        ..targetValues = [69]
        ..easing = Linear.INOUT
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.ANY
        ..start(myManager);
    });
  
  });
    
}