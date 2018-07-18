part of tweenengine.canvasexample;

class SimpleTimeline extends Screen {
  Vector2 pos, size;
  Color color;

  SimpleTimeline(CanvasRenderingContext2D context)
      : super(context, "Simple Timeline");

  initialize() {
    pos = Vector2();
    size = Vector2();
    color = Color();

    this.info = """A 'timeline' sequences multiple tweens (or other timelines)
        either one after the other, or all at once. Press escape to go back""";

    Timeline.sequence()
      ..push(Tween.set(pos, VectorAccessor.xy)..targetValues = [100, 100])
      ..push(Tween.set(size, VectorAccessor.xy)..targetValues = [30, 30])
      ..push(
          Tween.set(color, ColorAccessor.rgba)..targetValues = [255, 255, 0, 1])
      ..beginParallel()
      ..push(Tween.to(pos, VectorAccessor.xy, 1)..targetRelative = [200, 80])
      ..push(Tween.to(size, VectorAccessor.xy, 1)..targetRelative = [50, 0])
      ..push(
          Tween.to(color, ColorAccessor.rgb, 1)..targetRelative = [-255, 0, 0])
      ..end()
      ..beginParallel()
      ..push(Tween.to(pos, VectorAccessor.xy, 1)..targetRelative = [-100, 80])
      ..push(Tween.to(size, VectorAccessor.xy, 1)..targetRelative = [-50, 20])
      ..push(
          Tween.to(color, ColorAccessor.rgb, 1)..targetRelative = [0, -255, 0])
      ..end()
      ..push(Tween.to(color, ColorAccessor.rgba, 1)
        ..targetValues = [255, 255, 255, 0])
      ..repeat(Tween.infinity, 0.5)
      ..start(_tweenManager);
  }

  render(num delta) {
    super.render(delta);
    _tweenManager.update(delta);
    context
      ..beginPath()
      ..rect(pos.x, pos.y, size.x, size.y)
      ..setFillColorRgb(
          color.r.toInt(), color.g.toInt(), color.b.toInt(), color.a)
      ..fill()
      ..lineWidth = 2
      ..setStrokeColorRgb(255, 255, 255, color.a)
      ..stroke();
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
