part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Quad extends TweenEquation {
  Quad._();
  static num _computeInOut(num t) {
    if ((t *= 2) < 1) return 0.5 * t * t;
    return -0.5 * ((--t) * (t - 2) - 1);
  }

  static final Quad easeIn = Quad._()
    ..name = "Quad.easeIn"
    ..compute = (num t) => t * t;

  static final Quad easeOut = Quad._()
    ..name = "Quad.easeOut"
    ..compute = (num t) => -t * (t - 2);

  static final Quad easeInOut = Quad._()
    ..name = "Quad.easeInOut"
    ..compute = _computeInOut;
}
