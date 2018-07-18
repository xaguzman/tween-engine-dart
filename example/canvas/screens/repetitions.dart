part of tweenengine.canvasexample;

class Repetitions extends Screen {
  Vector2 pos1, pos2;

  Repetitions(CanvasRenderingContext2D context) : super(context, "Repetitions");

  initialize() {
    pos1 = Vector2();
    pos2 = Vector2();

    this.info =
        "Difference between 'repeat' and 'repeat yoyo'. Press escape to go back ";

    Timeline.sequence()
      ..push(Tween.set(pos1, VectorAccessor.xy)..targetValues = [100, 90])
      ..push(Tween.set(pos2, VectorAccessor.xy)..targetValues = [100, 170])
      ..beginParallel()
      ..push(Tween.to(pos1, VectorAccessor.xy, 1)
        ..targetRelative = [300, 0]
        ..repeat(1, 0.3))
      ..push(Tween.to(pos2, VectorAccessor.xy, 1)
        ..targetRelative = [300, 0]
        ..repeatYoyo(1, 0.3))
      ..end()
      ..repeat(Tween.infinity, 0.5)
      ..start(_tweenManager);
  }

  render(num delta) {
    super.render(delta);
    _tweenManager.update(delta);
    context
      ..beginPath()
      ..fillStyle = 'yellow'
      ..rect(pos1.x, pos1.y, 30, 30)
      ..rect(pos2.x, pos2.y, 30, 30)
      ..fill()
      ..fillStyle = 'white'
      ..fillText("Normal", 15, 120)
      ..fillText("Yoyo", 15, 200);
    ;
  }

  void onKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ESC) {
      app.setScreen(MainMenu(context));
      dispose();
    }
  }

  dispose() {
    _tweenManager.killAll();
  }
}
