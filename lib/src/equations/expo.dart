part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Expo extends TweenEquation {
  Expo._();
  static num _computeIn(num t) => (t == 0) ? 0 : math.pow(2, 10 * (t - 1));

  static num _computeOut(num t) => (t == 1) ? 1 : -math.pow(2, -10 * t) + 1;

  static num _computeInOut(num t) {
    if (t == 0) return 0;
    if (t == 1) return 1;
    if ((t *= 2) < 1) return 0.5 * math.pow(2, 10 * (t - 1));
    return 0.5 * (-math.pow(2, -10 * --t) + 2);
  }

  static final Expo easeIn = Expo._()
    ..name = "Expo.easeIn"
    ..compute = _computeIn;

  static final Expo easeOut = Expo._()
    ..name = "Expo.easeOut"
    ..compute = _computeOut;

  static final Expo easeInOut = Expo._()
    ..name = "Expo.easeInOut"
    ..compute = _computeInOut;
}
