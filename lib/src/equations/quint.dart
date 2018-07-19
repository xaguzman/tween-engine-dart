part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Quint extends TweenEquation {
  Quint._();
  static num _computeInOut(num t) {
    if ((t *= 2) < 1) return 0.5 * t * t * t * t * t;
    return 0.5 * ((t -= 2) * t * t * t * t + 2);
  }

  static final Quint easeIn = Quint._()
    ..name = "Quint.easeIn"
    ..compute = (num t) => t * t * t * t * t;

  static final Quint easeOut = Quint._()
    ..name = "Quint.easeOut"
    ..compute = (num t) => (t -= 1) * t * t * t * t + 1;

  static final Quint easeInOut = Quint._()
    ..name = "Quint.easeInOut"
    ..compute = _computeInOut;
}
