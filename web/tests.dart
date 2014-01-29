part of tweenengine.tests;


typedef void Callback(Test source);

/**
 * @author Aurelien Ribon | http://www.aurelienribon.com/
 */
abstract class Test {
  final TweenManager _tweenManager = new TweenManager();
  List<bool> _useDots;
  CanvasRenderingContext2D context;
  String font;
  Callback _callback;
  
  Vector2 vector1, vector2;
  String title = "", info = '';
  
  num wpw = 10;
  num wph ;
  
  Test(this.context){
    this.wph = 10;
    this.wph = 10 * (context.canvas.height / context.canvas.width);
    
    int w = context.canvas.width;
    
    if (w > 600) 
      font = "normal 24pt arial";
    else 
      font = "normal 16pt arial";
  }
    
  void dotCallBack(int type, BaseTween source){
    
  }
  
  initialize();
  
  render(num delta){
    context.font = this.font;
    context.fillStyle = 'White';
    context.fillText("$title", 130, 30);
    //context.fillText("$info", 40, 60);
  }
  
  dispose();
}

class Functions extends Test{
  List<Vector2> vectors;
  int state;
  
  Functions(CanvasRenderingContext2D context): super(context);
  
  initialize(){
    vectors = [
      new Vector2( 40, 60),
      new Vector2( 80, 130),
      new Vector2( 50, 90),
      new Vector2( 200, 200)
    ];    
    
    this.title = "Easing functions";
    this.info = """The most common easing functions - used in JQuery and Flash - are available,
        plus your owns (click canvas to switch functions).""";
    startFunctions1(0.5);
    context.canvas.onClick.listen( (MouseEvent e){
      switch (state) {
        case 0: reset(0.5); startFunctions2(1.0); break;
        case 1: reset(0.5); startFunctions3(1.0); break;
        case 2: reset(0.5); startFunctions1(1.0); break;
      }
    });
  }
  
  void reset(num duration) {
    _tweenManager.killAll();

    Timeline.createParallel()
      ..push(Tween.set(vectors[0], VectorAccessor.XY)
          ..targetValues = [40, 60])
      ..push(Tween.set(vectors[1], VectorAccessor.XY)
          ..targetValues = [80, 130])
      ..push(Tween.set(vectors[2], VectorAccessor.XY)
          ..targetValues = [50, 90])
      ..push(Tween.set(vectors[3], VectorAccessor.XY)
          ..targetValues = [200, 200])
      ..start(_tweenManager);
  }
  
  startFunctions1(num delay){
    state = 0;
    
    Timeline.createParallel()
      ..push(Tween.to(vectors[0], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Quad.INOUT)
      ..push(Tween.to(vectors[1], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Cubic.INOUT)
      ..push(Tween.to(vectors[2], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Quart.INOUT)
      ..push(Tween.to(vectors[3], VectorAccessor.XY, 1)
          ..targetRelative = [100, -50]
          ..easing = Quint.INOUT)
      ..repeat(Tween.INFINITY, 1)
      ..delay = delay
      ..start(_tweenManager);
  }
  
  startFunctions2(num delay){
    state = 1;
    
    Timeline.createParallel()
      ..push(Tween.to(vectors[0], VectorAccessor.XY, 1.0)
          ..targetRelative = [100, 0]
          ..easing = Linear.INOUT)
      ..push(Tween.to(vectors[1], VectorAccessor.XY, 1.0)
          ..targetRelative = [100, 0]
          ..easing = Sine.INOUT)
      ..push(Tween.to(vectors[2], VectorAccessor.XY, 1.0)
          ..targetRelative = [100, 0]
          ..easing = Expo.INOUT)
      ..push(Tween.to(vectors[3], VectorAccessor.XY, 1.0)
          ..targetRelative = [100, -50]
          ..easing = Circ.INOUT)
      ..repeat(-1, 1.0)
      ..delay = delay
      ..start(_tweenManager);
  }
  
  startFunctions3(num delay){
    state = 2;
    
    var timeline = Timeline.createParallel()
      ..push(Tween.to(vectors[0], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Back.OUT)
      ..push(Tween.to(vectors[1], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Elastic.OUT)
      ..push(Tween.to(vectors[2], VectorAccessor.XY, 1)
          ..targetRelative = [100, 0]
          ..easing = Bounce.OUT)
          ..push(Tween.to(vectors[3], VectorAccessor.XY, 1)
          ..targetRelative = [100, -50]
          ..easing = Bounce.IN)
      ..repeat(Tween.INFINITY, 1)
      ..delay = delay
      ..start(_tweenManager);
  }
  
  render(num delta){
    super.render(delta);
    _tweenManager.update(delta);
        
    vectors.forEach( (Vector2 v) {
      context.beginPath();
      context.rect(v.x, v.y, 20, 20);
      context.fillStyle = 'yellow';
      context.fill();
      context.lineWidth = 1;
      context.strokeStyle = 'white';
      context.stroke();
    });
  }
  
  dispose(){
    _tweenManager.killAll();
  }
  
}