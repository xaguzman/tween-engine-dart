import 'dart:html';
import 'dart:math';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

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
    if ( tween.userData is String){
      if (tween.userData == 'time'){
        print('local: ${tween.currentTime}');
        print('normal local: ${tween.normalTime}');
      }
    }
    
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
    
    deltaInSeconds = min(deltaInSeconds, 1 / 30); 

    lastUpdate = timestampInMs;

    myManager.update(deltaInSeconds);
    window.animationFrame.then(update);
  }

  window.animationFrame.then(update);
  Tween.registerAccessor(MyClass, new MyAccessor());
  
  group('Normalized time', () {
    test('Tween.to', () {
      var myClass = new MyClass();
      
      // start / begin
      Function expectOnBegin = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(0)); 
      }, count: 2);
      
      // end / complete
      Function expectOnComplete = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(1));
      }, count: 2);
      
      
      TweenCallbackHandler callback = (int type, BaseTween tween){
        if ( type == TweenCallback.BEGIN || type == TweenCallback.START )
          expectOnBegin(tween);
        else if ( type == TweenCallback.COMPLETE || type == TweenCallback.END )
          expectOnComplete(tween);
      };
      
      new Tween.to(myClass, 1, 0.25)
        ..targetValues = [20,20]
        ..callback = callback
        ..callbackTriggers = TweenCallback.ANY
        ..userData = 'time'
        ..start(myManager);
    });
    
    test('Tween.from', () {
        var myClass = new MyClass();
        
        // start / begin
        Function expectOnBegin = expectAsync1((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        }, count: 2);
        
        // end / complete
        Function expectOnComplete = expectAsync1((BaseTween tween){
          expect(tween.normalTime, equals(1));
        }, count: 2);
        
        
        TweenCallbackHandler callback = (int type, BaseTween tween){
          if ( type == TweenCallback.BEGIN || type == TweenCallback.START )
            expectOnBegin(tween);
          else if ( type == TweenCallback.COMPLETE || type == TweenCallback.END )
            expectOnComplete(tween);
        };
        
        new Tween.from(myClass, 1, 0.25)
          ..targetValues = [20,20]
          ..callback = callback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..start(myManager);
      });
    
    test('repeat', () {
      var myClass = new MyClass();
      
      Function expectOnBegin = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(0)); 
      });
      
      Function expectOnStart = expectAsync1((BaseTween tween){
        expect(tween.normalTime, lessThan(1)); 
      }, count : 2);
      
      Function expectOnEnd = expectAsync1((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
      }, count: 2);
      
      Function expectOnComplete = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(1));
      });
      
      
      TweenCallbackHandler myCallback = (type, tween) {
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
      
      new Tween.to(myClass, 1, 0.25)
        ..targetValues = [20,20]
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.ANY
        ..repeat(1, 0)
        ..userData = 'time'
        ..start(myManager);
    }); 
    
    test('repeat yoyo', () {
      var myClass = new MyClass();
      
      Function expectOnBegin = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(0)); 
      });
      
      Function expectOnStart = expectAsync1((BaseTween tween){
        expect(tween.normalTime, lessThan(1)); 
      }, count : 2);
      
      Function expectOnEnd = expectAsync1((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
      }, count: 2);
      
      Function expectOnComplete = expectAsync1((BaseTween tween){
        expect(tween.normalTime, equals(1));
      });
      
      
      TweenCallbackHandler myCallback = (type, tween) {
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
      
      new Tween.to(myClass, 1, 0.25)
        ..targetValues = [20,20]
        ..callback = myCallback
        ..callbackTriggers = TweenCallback.ANY
        ..repeatYoyo(1, 0)
        ..userData = 'time'
        ..start(myManager);
    });
    
  });
}

