part of tweenengine;

/// Easing equation based on Robert Penner's work:
/// http://robertpenner.com/easing/
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Elastic extends TweenEquation {
  //static final num PI = 3.14159265f;

  num paramA = 0;
  num paramP = 0;
  bool setA = false;
  bool setP = false;

  Elastic._();

  void a(num a) {
    paramA = a;
    this.setA = true;
  }

  void p(num p) {
    paramP = p;
    this.setP = true;
  }

  static num _computeIn(num t) {
    //num a = param_a;
    //num p = param_p;
    if (t == 0) return 0;
    if (t == 1) return 1;
    //if (!setP)
    num p = 0.3;
    num s;
    //if (!setA || a < 1) {
    num a = 1;
    s = p / 4;
//    }else
//      s = p / (2* Math.PI) * Math.asin(1/a);

    return -(a *
        math.pow(2, 10 * (t -= 1)) *
        math.sin((t - s) * (2 * math.pi) / p));
  }

  static num _computeOut(num t) {
//    num a = param_a;
//    num p = param_p;
    if (t == 0) return 0;
    if (t == 1) return 1;
//    if (!setP)
    num p = 0.3;
    num s;
//    if (!setA || a < 1) {
    num a = 1;
    s = p / 4;
//    }else
//      s = p/(2*Math.PI) * Math.asin(1/a);
    return a * math.pow(2, -10 * t) * math.sin((t - s) * (2 * math.pi) / p) + 1;
  }

  static num _computeInOut(num t) {
//    num a = param_a;
//    num p = param_p;
    if (t == 0) return 0;
    if ((t *= 2) == 2) return 1;

//    if (!setP)
    num p = 0.3 * 1.5;
    num s;
//    if (!setA || a < 1) {
    num a = 1;
    s = p / 4;
//    }
//    else s = p/(2*Math.PI) * Math.asin(1/a);
    if (t < 1)
      return -0.5 *
          (a *
              math.pow(2, 10 * (t -= 1)) *
              math.sin((t - s) * (2 * math.pi) / p));
    return a *
            math.pow(2, -10 * (t -= 1)) *
            math.sin((t - s) * (2 * math.pi) / p) *
            0.5 +
        1;
  }

  static final Elastic easeIn = Elastic._()
    ..name = "Elastic.easeIn"
    ..compute = _computeIn;

  static final Elastic easeOut = Elastic._()
    ..name = "Elastic.easeOut"
    ..compute = _computeOut;

  static final Elastic easeInOut = Elastic._()
    ..name = "Elastic.easeInOut"
    ..compute = _computeInOut;
}
