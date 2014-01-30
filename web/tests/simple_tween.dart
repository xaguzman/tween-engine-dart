part of tweenengine.tests;

class SimpleTween extends Test{
  Vector2 pos;
  
  SimpleTween(CanvasRenderingContext2D context): super(context);
  
  initialize(){
    
    pos = new Vector2(150, 200);
    
    this.title = "Simple Tween";
    this.info = """A 'tween' is an interpolation from a value to another
        (click anywhere in the canvas to start a 'position tween')""";
  }
  
  void onClick(MouseEvent e){
    num x =  e.client.x;
    num y = e.client.y;
    
    Tween.to(pos, VectorAccessor.XY, 1)
      ..delay = 0.3
      ..targetValues = [x, y]
    ..start(_tweenManager);
  } 
  
  
  
  render(num delta){
    super.render(delta);
    _tweenManager.update(delta);
    
    context
      ..beginPath()
      ..rect(pos.x, pos.y, 20, 20)
      ..fillStyle = 'yellow'
      ..fill()
      ..lineWidth = 1
      ..strokeStyle = 'white'
      ..stroke();
  }
  
  dispose(){
    _tweenManager.killAll();
  }
  
}