part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Cubic extends TweenEquation {
  Cubic._();
  static num _computeIn(num time) => time * time * time;

  static num _computeOut(num t) => (t -= 1) * t * t + 1;

  static num _computeInOut(num t) {
    if ((t *= 2) < 1) return 0.5 * t * t * t;
    return 0.5 * ((t -= 2) * t * t + 2);
  }

  static final Cubic easeIn = Cubic._()
    ..name = "Cubic.easeIn"
    ..compute = _computeIn;

  static final Cubic easeOut = Cubic._()
    ..name = "Cubic.easeOut"
    ..compute = _computeOut;

  static final Cubic easeInOut = Cubic._()
    ..name = "Cubic.easeInOut"
    ..compute = _computeInOut;
}
