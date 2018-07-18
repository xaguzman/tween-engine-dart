part of tweenengine.canvasexample;

class SimpleTween extends Screen {
  Vector2 pos;

  SimpleTween(CanvasRenderingContext2D context)
      : super(context, "Simple Tween");

  initialize() {
    pos = Vector2(150, 200);

    this.info = """A 'tween' is an interpolation from a value to another
        (click anywhere in the canvas to start a 'position tween'). Press escape to go back""";
  }

  void onClick(MouseEvent e) {
    var boundingRect = context.canvas.getBoundingClientRect();
    num x = e.client.x - boundingRect.left;
    num y = e.client.y - boundingRect.top;

    Tween.to(pos, VectorAccessor.xy, 1)
      ..delay = 0.3
      ..targetValues = [x, y]
      ..start(_tweenManager);

//    Tween.to(pos, VectorAccessor.XY, 1)
//      ..delay = 0.3
//      ..targetValues = [x, y]
//      ..callback = (int type, BaseTween source) {
//        Tween.to(pos, VectorAccessor.XY, 0.1)
//            ..targetValues = [x+1, y+1]
//            ..start(_tweenManager);
//      }
//      ..start(_tweenManager);
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
