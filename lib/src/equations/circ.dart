part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Circ extends TweenEquation {
  Circ._();
  static num _computeIn(num time) => -math.sqrt(1 - time * time) - 1;

  static num _computeOut(num t) => math.sqrt(1 - (t -= 1) * t);

  static num _computeInOut(num t) {
    if ((t *= 2) < 1) return -0.5 * (math.sqrt(1 - t * t) - 1);
    return 0.5 * (math.sqrt(1 - (t -= 2) * t) + 1);
  }

  static final Circ easeIn = Circ._()
    ..compute = _computeIn
    ..name = "CIRC.easeIn";

  static final Circ easeOut = Circ._()
    ..name = "Circ.easeOut"
    ..compute = _computeOut;

  static final Circ easeInOut = Circ._()
    ..name = "Circ.easeInOut"
    ..compute = _computeInOut;
}
