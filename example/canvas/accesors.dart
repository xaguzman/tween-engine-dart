part of tweenengine.canvasexample;

class Vector2 {
  num x, y;
  Vector2([this.x = 0, this.y = 0]);
  String toString() => "[$x , $y]";
}

class Color {
  num r, g, b, a;
  Color([this.r = 0, this.g = 0, this.b = 0, this.a = 1]);
  String toString() => "[r: $r, g: $g, b: $b, a: $a]";
}

class VectorAccessor implements TweenAccessor<Vector2> {
  static const int XY = 1;

  int getValues(
      Vector2 target, Tween tween, int tweenType, List<num> returnValues) {
    returnValues[0] = target.x;
    returnValues[1] = target.y;

    return 2;
  }

  void setValues(
      Vector2 target, Tween tween, int tweenType, List<num> newValues) {
    target
      ..x = newValues[0]
      ..y = newValues[1];
  }
}

class ColorAccessor implements TweenAccessor<Color> {
  static const RGB = 1;
  static const RGBA = 2;

  int getValues(
      Color target, Tween tween, int tweenType, List<num> returnValues) {
    switch (tweenType) {
      case RGBA:
        returnValues[0] = target.r;
        returnValues[1] = target.g;
        returnValues[2] = target.b;
        returnValues[3] = target.a;
        return 4;
      case RGB:
        returnValues[0] = target.r;
        returnValues[1] = target.g;
        returnValues[2] = target.b;
        return 3;
      default:
        return 0;
    }
  }

  void setValues(
      Color target, Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case RGBA:
        target
          ..r = newValues[0]
          ..g = newValues[1]
          ..b = newValues[2]
          ..a = newValues[3];
        break;
      case RGB:
        target
          ..r = newValues[0]
          ..g = newValues[1]
          ..b = newValues[2];
        break;
    }
  }
}
