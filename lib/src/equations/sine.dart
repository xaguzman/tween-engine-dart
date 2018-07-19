part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Sine extends TweenEquation {
  //private static final float PI = 3.14159265f;

  static final Sine easeIn = Sine._()
    ..name = "Sine.easeIn"
    ..compute = (num t) => -math.cos(t * (math.pi / 2)) + 1;

  static final Sine easeOut = Sine._()
    ..name = "Sine.easeOut"
    ..compute = (num t) => math.sin(t * (math.pi / 2));

  static final Sine easeInOut = Sine._()
    ..name = "Sine.easeInOut"
    ..compute = (num t) => -0.5 * (math.cos(math.pi * t) - 1);

  Sine._();
}
