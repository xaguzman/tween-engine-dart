part of tweenengine.canvasexample;

class MainMenu extends Screen {
  List<List<Screen>> screens;
  List<List<Rectangle>> areas;

  MainMenu(CanvasRenderingContext2D context) : super(context, "Tween Engine");

  void initialize() {
    num width = 125;
    num height = 80;

    screens = [
      [SimpleTween(context), SimpleTimeline(context), Repetitions(context)],
      [Functions(context), Waypoints(context)]
    ];

    areas = [
      [
        Rectangle(30, 80, width, height),
        Rectangle(175, 80, width, height),
        Rectangle(320, 80, width, height)
      ],
      [Rectangle(85, 190, width, height), Rectangle(245, 190, width, height)]
    ];

    this.info = "Click on the example you want to see";
  }

  void onClick(MouseEvent e) {
    var boundingRect = context.canvas.getBoundingClientRect();
    num x = e.client.x - boundingRect.left;
    num y = e.client.y - boundingRect.top;

    for (int i = 0; i < areas.length; i++) {
      for (int j = 0; j < areas[i].length; j++) {
        Rectangle area = areas[i][j];

        if (area.left <= x &&
            area.left + area.width >= x &&
            area.top <= y &&
            area.top + area.height >= y) {
          app.setScreen(screens[i][j]);
          break;
        }
      }
    }
  }

  void render(num delta) {
    super.render(delta);
    _tweenManager.update(delta);

    for (int i = 0; i < areas.length; i++) {
      for (int j = 0; j < areas[i].length; j++) {
        Rectangle area = areas[i][j];
        Screen screen = screens[i][j];

        var textX =
            area.left + (area.width * 0.5) - (screen.title.length * 3.1);
        context
          ..beginPath()
          ..rect(area.left, area.top, area.width, area.height)
          ..setFillColorRgb(21, 108, 153)
          ..fill()
          ..fillStyle = 'white'
          ..font = "normal 10pt arial"
          ..fillText(screen.title, textX, area.top + area.height * 0.9);
      }
    }
  }

  void dispose() {
    _tweenManager.killAll();
  }
}
