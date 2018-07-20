part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Bounce extends TweenEquation {
  Bounce._();
  static num _computeIn(num time) => 1 - _computeOut(1 - time);

  static num _computeOut(num t) {
    if (t < (1 / 2.75)) {
      return 7.5625 * t * t;
    } else if (t < (2 / 2.75)) {
      return 7.5625 * (t -= (1.5 / 2.75)) * t + .75;
    } else if (t < (2.5 / 2.75)) {
      return 7.5625 * (t -= (2.25 / 2.75)) * t + .9375;
    } else {
      return 7.5625 * (t -= (2.625 / 2.75)) * t + .984375;
    }
  }

  static num _computeInOut(num t) {
    if (t < 0.5)
      return _computeIn(t * 2) * 0.5;
    else
      return _computeOut(t * 2 - 1) * 0.5 + 0.5;
  }

  static final Bounce easeIn = Bounce._()
    ..name = "Bounce.easeIn"
    ..compute = _computeIn;

  static final Bounce easeOut = Bounce._()
    ..name = "Bounce.easeOut"
    ..compute = _computeOut;

  static final Bounce easeInOut = Bounce._()
    ..name = "Bounce.easeInOut"
    ..compute = _computeInOut;
}
