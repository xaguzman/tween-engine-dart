part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Quart extends TweenEquation {
  static num _computeInOut(num t) {
    if ((t *= 2) < 1) return 0.5 * t * t * t * t;
    return -0.5 * ((t -= 2) * t * t * t - 2);
  }

  static final Quart easeIn = Quart()
    ..name = "Quart.easeIn"
    ..compute = (num t) => t * t * t * t;

  static final Quart easeOut = Quart()
    ..name = "Quart.easeOut"
    ..compute = (num t) => -((t -= 1) * t * t * t - 1);

  static final Quart easeInOut = Quart()
    ..name = "Quart.easeInOut"
    ..compute = _computeInOut;
}
