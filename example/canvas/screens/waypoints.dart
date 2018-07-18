part of tweenengine.canvasexample;

class Waypoints extends Screen {
  Vector2 pos;
  List<Vector2> waypoints = List<Vector2>();

  Waypoints(CanvasRenderingContext2D context) : super(context, "Waypoints");

  initialize() {
    pos = Vector2(50, 30);
    waypoints.add(Vector2(200, 100));
    waypoints.add(Vector2(100, 250));
    waypoints.add(Vector2(250, 250));
    waypoints.add(Vector2(380, 50));

    this.info =
        """Tweens can navigate through waypoints, which define a 'bezier' path (here 
                    using a Catmull-Rom spline). Press escape to go back""";

    Tween.to(pos, VectorAccessor.XY, 3)
      ..addWaypoint([waypoints[0].x, waypoints[0].y])
      ..addWaypoint([waypoints[1].x, waypoints[1].y])
      ..addWaypoint([waypoints[2].x, waypoints[2].y])
      ..addWaypoint([waypoints[3].x, waypoints[3].y])
      ..targetValues = [350, 250]
      ..easing = Quad.INOUT
      ..path = TweenPaths.catmullRom
      ..repeatYoyo(Tween.INFINITY, 0.2)
      ..delay = 0.5
      ..start(_tweenManager);
  }

  void onKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ESC) {
      app.setScreen(MainMenu(context));
      dispose();
    }
  }

  render(num delta) {
    super.render(delta);
    _tweenManager.update(delta);

    int i = 0;
    waypoints.forEach((Vector2 obj) {
      i++;
      context
        ..fillStyle = 'White'
        ..fillText(i.toString(), obj.x, obj.y)
        ..beginPath()
        ..arc(obj.x, obj.y, 2, 0, 2 * PI)
        ..fillStyle = 'red'
        ..fill()
        ..lineWidth = 1
        ..strokeStyle = 'white'
        ..stroke();
    });

    context
      ..beginPath()
      ..rect(pos.x, pos.y, 20, 20)
      ..fillStyle = 'yellow'
      ..fill()
      ..lineWidth = 1
      ..strokeStyle = 'white'
      ..stroke();
  }

  dispose() {
    _tweenManager.killAll();
  }
}
