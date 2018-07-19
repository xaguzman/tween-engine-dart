part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Linear extends TweenEquation {
  static final Linear easeInOut = Linear._()
    ..name = "Linear.easeInOut"
    ..compute = (num t) => t;

  Linear._();
}
