part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Back extends TweenEquation {
  Back._();
  static num _paramS = 1.70158;

  static num _computeIn(num time) {
    num s = _paramS;
    return time * time * ((s + 1) * time - s);
  }

  static num _computeOut(num time) {
    num s = _paramS;
    return (time -= 1) * time * ((s + 1) * time + s) + 1;
  }

  static num _computeInOut(num time) {
    num s = _paramS;
    if ((time *= 2) < 1)
      return 0.5 * (time * time * (((s *= (1.525)) + 1) * time - s));
    return 0.5 * ((time -= 2) * time * (((s *= (1.525)) + 1) * time + s) + 2);
  }

  static final Back easeIn = Back._()
    ..compute = _computeIn
    ..name = "BACK.easeIn";

  static final Back easeOut = Back._()
    ..compute = _computeOut
    ..name = "BACK.easeOut";

  static final Back easeInOut = Back._()
    ..compute = _computeInOut
    ..name = "BACK.easeInOut";
}
