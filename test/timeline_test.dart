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
    if ( tween.userData is String){
      if (tween.userData == 'time'){
        print('normal time: ${tween.normalTime}');
        print('currentTime time: ${tween.currentTime}');
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
  group('Normalized time', () {
     test('for normal sequence', () {
        var myClass = new MyClass();
       
        Function expectOnBegin = expectAsync((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        });
        
        Function expectOnStart = expectAsync((BaseTween tween){
          expect(tween.normalTime, lessThan(1)); 
        });
        
        Function expectOnEnd = expectAsync((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
        });
        
        Function expectOnComplete = expectAsync((BaseTween tween){
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
        
        new Timeline.sequence()
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [20, 20])
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [40, 40])
          ..callback = myCallback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..start(myManager);
      });
      
      test('for normal parallel', () {
        var myClass = new MyClass();
       
        Function expectOnBegin = expectAsync((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        });
        
        Function expectOnStart = expectAsync((BaseTween tween){
          expect(tween.normalTime, lessThan(1)); 
        });
        
        Function expectOnEnd = expectAsync((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
        });
        
        Function expectOnComplete = expectAsync((BaseTween tween){
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
        
        new Timeline.parallel()
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [20, 20])
          ..push(
              new Tween.to(myClass, 1, 0.12)
                ..targetValues = [40, 40])
          ..callback = myCallback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..start(myManager);
      });
      
      test('for repeat sequence', () {
        var myClass = new MyClass();
       
        Function expectOnBegin = expectAsync((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        });
        
        Function expectOnStart = expectAsync((BaseTween tween){
          expect(tween.normalTime, lessThan(1)); 
        }, count:2);
        
        Function expectOnEnd = expectAsync((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
        }, count: 2);
        
        Function expectOnComplete = expectAsync((BaseTween tween){
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
        
        new Timeline.sequence()
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [20, 20])
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [40, 40])
          ..callback = myCallback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..repeat(1, 0)
          ..start(myManager);
      });
      
      test('for repeat parallel', () {
        var myClass = new MyClass();
       
        Function expectOnBegin = expectAsync((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        });
        
        Function expectOnStart = expectAsync((BaseTween tween){
          expect(tween.normalTime, lessThan(1)); 
        }, count:2);
        
        Function expectOnEnd = expectAsync((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
        }, count: 2);
        
        Function expectOnComplete = expectAsync((BaseTween tween){
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
        
        new Timeline.parallel()
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [20, 20])
          ..push(
              new Tween.to(myClass, 1, 0.13)
                ..targetValues = [40, 40])
          ..callback = myCallback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..repeat(1, 0)
          ..start(myManager);
      });
      
      test('for repeat yoyo sequence', () {
              var myClass = new MyClass();
             
              Function expectOnBegin = expectAsync((BaseTween tween){
                expect(tween.normalTime, equals(0)); 
              });
              
              Function expectOnStart = expectAsync((BaseTween tween){
                expect(tween.normalTime, lessThan(1)); 
              }, count:2);
              
              Function expectOnEnd = expectAsync((BaseTween tween){
                expect(tween.normalTime, greaterThan(0));
              }, count: 2);
              
              Function expectOnComplete = expectAsync((BaseTween tween){
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
              
              new Timeline.sequence()
                ..push(
                    new Tween.to(myClass, 1, 0.1)
                      ..targetValues = [20, 20])
                ..push(
                    new Tween.to(myClass, 1, 0.1)
                      ..targetValues = [40, 40])
                ..callback = myCallback
                ..callbackTriggers = TweenCallback.ANY
                ..userData = 'time'
                ..repeatYoyo(1, 0)
                ..start(myManager);
            });
            
      test('for repeat yoyo parallel', () {
        var myClass = new MyClass();
       
        Function expectOnBegin = expectAsync((BaseTween tween){
          expect(tween.normalTime, equals(0)); 
        });
        
        Function expectOnStart = expectAsync((BaseTween tween){
          expect(tween.normalTime, lessThan(1)); 
        }, count:2);
        
        Function expectOnEnd = expectAsync((BaseTween tween){
          expect(tween.normalTime, greaterThan(0));
        }, count: 2);
        
        Function expectOnComplete = expectAsync((BaseTween tween){
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
        
        new Timeline.parallel()
          ..push(
              new Tween.to(myClass, 1, 0.1)
                ..targetValues = [20, 20])
          ..push(
              new Tween.to(myClass, 1, 0.13)
                ..targetValues = [40, 40])
          ..callback = myCallback
          ..callbackTriggers = TweenCallback.ANY
          ..userData = 'time'
          ..repeatYoyo(1, 0)
          ..start(myManager);
      });
  });
  
  group('Other', () {
    test('-killing timeline from within a child tween', (){
      var myObj = new MyClass();
      num killedByTween = -1;
      Timeline rootTimeline;
      
      
      Function timelineElapsedLessThan1 = expectAsync(  ( ){
        //this  function should only  be called by first tween
        expect(killedByTween, equals(1));
        expect(rootTimeline.currentTime, lessThan(1));
      });
      
      TweenCallbackHandler killTimeline = (int type, BaseTween tween){
        killedByTween = tween.userData as num;
        rootTimeline.kill();
        timelineElapsedLessThan1();
      };
            
      rootTimeline = new Timeline.sequence()
        ..beginParallel()
          ..push(
            new Tween.to(myObj, 1, 0.9)
              ..targetRelative = [5,5]
              ..userData = 1
              ..callback = killTimeline
              ..callbackTriggers = TweenCallback.COMPLETE)
          ..push(
              new Tween.to(myObj, 1, 1.3)
                ..targetRelative=[5,5]
                ..userData = 2
                ..callback = killTimeline
                ..callbackTriggers = TweenCallback.COMPLETE)
        ..end()
        ..push( 
            new Tween.to(myObj, 1, 1)
              ..targetRelative=[5,5]
              ..userData = 3
              ..callback = killTimeline
              ..callbackTriggers = TweenCallback.COMPLETE)
        ..start(myManager);
     });
  });
}