part of tweenengine.example;

class Waypoints extends Screen{
  Vector2 pos;
  
  Waypoints(CanvasRenderingContext2D context): super(context, "Waypoints");
  
  initialize(){
    
    pos = new Vector2(50, 30);
    
    this.info = """Tweens can navigate through waypoints, which define a 'bezier' path (here 
                    using a Catmull-Rom spline). Press escape to go back""";
    
    Tween.to(pos, VectorAccessor.XY, 3)
      ..addWaypoint ([200,100] )
      ..addWaypoint ([150, 150])
      ..addWaypoint ([180, 180])
      ..addWaypoint ([380, 50])
      ..targetValues = [350, 250]
      ..easing = Quad.INOUT
      ..path = TweenPaths.catmullRom
      ..repeatYoyo(Tween.INFINITY, 0.2)
      ..delay = 0.5
      ..start(_tweenManager);
  }
  
  void onKeyDown(KeyboardEvent e){
    if (e.keyCode == KeyCode.ESC){
      app.setScreen(new MainMenu(context));
      dispose();
    }
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