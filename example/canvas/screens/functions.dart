part of tweenengine.canvasexample;

class Functions extends Screen {
  List<Vector2> vectors;
  Map<int, List<TweenEquation>> equations;
  int state;

  Functions(CanvasRenderingContext2D context)
      : super(context, "Easing Functions");

  initialize() {
    vectors = [
      Vector2(160, 90),
      Vector2(160, 130),
      Vector2(160, 170),
      Vector2(160, 210)
    ];
    equations = {
      0: [Quad.INOUT, Cubic.INOUT, Quart.INOUT, Quint.INOUT],
      1: [Linear.INOUT, Sine.INOUT, Expo.INOUT, Circ.INOUT],
      2: [Back.INOUT, Elastic.INOUT, Bounce.INOUT]
    };
    state = 0;
    this.info =
        """The most common easing functions - used in JQuery and Flash - are available,
        plus your owns (click canvas to switch functions). Press escape to go back""";
    startFunctions(0.5);
  }

  void onClick(MouseEvent e) {
    switch (state) {
      case 0:
        reset(0.5);
        state = 1;
        startFunctions(1.0);
        break;
      case 1:
        reset(0.5);
        state = 2;
        startFunctions(1.0);
        break;
      case 2:
        reset(0.5);
        state = 0;
        startFunctions(1.0);
        break;
    }
  }

  void onKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ESC) {
      app.setScreen(MainMenu(context));
      dispose();
    }
  }

  void reset(num duration) {
    _tweenManager.killAll();

    Timeline.parallel()
      ..push(Tween.set(vectors[0], VectorAccessor.XY)..targetValues = [160, 90])
      ..push(
          Tween.set(vectors[1], VectorAccessor.XY)..targetValues = [160, 130])
      ..push(
          Tween.set(vectors[2], VectorAccessor.XY)..targetValues = [160, 170])
      ..push(
          Tween.set(vectors[3], VectorAccessor.XY)..targetValues = [160, 210])
      ..start(_tweenManager);
  }

  startFunctions(num delay) {
    var timeline = Timeline.parallel()
      ..repeat(Tween.INFINITY, 1.0)
      ..delay = delay;

    for (int i = 0; i < equations[state].length; i++) {
      timeline.push(Tween.to(vectors[i], VectorAccessor.XY, 1.0)
        ..targetRelative = [250, 0]
        ..easing = equations[state][i]);
    }

    timeline.start(_tweenManager);
  }

  render(num delta) {
    super.render(delta);
    _tweenManager.update(delta);

    for (int i = 0; i < equations[state].length; i++) {
      Vector2 obj = vectors[i];
      context
        ..fillStyle = 'White'
        ..fillText(equations[state][i].name, 10, i * 40 + 110)
        ..beginPath()
        ..rect(obj.x, obj.y, 20, 20)
        ..fillStyle = 'yellow'
        ..fill()
        ..lineWidth = 1
        ..strokeStyle = 'white'
        ..stroke();
    }
  }

  dispose() {
    _tweenManager.killAll();
  }
}
