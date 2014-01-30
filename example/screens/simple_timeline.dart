part of tweenengine.tests;

class SimpleTimeline extends Screen{
  Vector2 pos, size;
  Color color;
  
  SimpleTimeline(CanvasRenderingContext2D context): super(context);
  
  initialize(){
    
    pos = new Vector2(); size = new Vector2();
    color = new Color();
    
    this.title = "Simple timeline";
    this.info = """A 'timeline' sequences multiple tweens (or other timelines)
        either one after the other, or all at once""";
    
    Timeline.createSequence()
      ..push(Tween.set(pos, VectorAccessor.XY)..targetValues = [100, 100])
      ..push(Tween.set(size, VectorAccessor.XY)..targetValues = [30, 30])
      ..push(Tween.set(color, ColorAccessor.RGBA)..targetValues = [255, 255, 0, 1])
      ..beginParallel()
        ..push(Tween.to(pos, VectorAccessor.XY, 1)..targetRelative = [200, 80])
        ..push(Tween.to(size, VectorAccessor.XY, 1)..targetRelative = [50, 0])
        ..push(Tween.to(color, ColorAccessor.RGB, 1)..targetRelative = [-255, 0, 0] )
      ..end()
      ..beginParallel()
        ..push(Tween.to(pos, VectorAccessor.XY, 1)..targetRelative = [-100, 80])
        ..push(Tween.to(size, VectorAccessor.XY, 1)..targetRelative = [-50, 20])
        ..push(Tween.to(color, ColorAccessor.RGB, 1)..targetRelative = [0, -255, 0] )
      ..end()
      ..push(Tween.to(color, ColorAccessor.RGBA, 1)..targetValues = [255, 255, 255, 0] )
      ..repeat(Tween.INFINITY, 0.5)
      ..start(_tweenManager);
      
  }
  
  render(num delta){
    super.render(delta);
    _tweenManager.update(delta);    
    context
      ..beginPath()
      ..rect(pos.x, pos.y, size.x, size.y)
      ..setFillColorRgb(color.r.toInt(), color.g.toInt(), color.b.toInt(), color.a)
      ..fill()
      ..lineWidth = 2
      ..setStrokeColorRgb(255, 255, 255, color.a)
      ..stroke();
  }
  
  dispose(){
    _tweenManager.killAll();
  }
  
}