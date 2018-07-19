part of tweenengine;

/// Computes the next value of the interpolation.
/// [time] The current time, between 0 and 1.
/// Returns the current value.
typedef num ComputingFunction(num time);

/// Base class for every easing equation. You can create your own equations
/// and directly use them in the Tween engine by inheriting from this class.
///
/// see [Tween]
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
abstract class TweenEquation {
  ///The [ComputingFunction] for this equation
  ComputingFunction compute;

  ///String representation of this function
  String name;

  /// Returns true if the given string is the name of this equation (the name
  /// is returned in the toString() method, don't forget to override it).
  /// This method is usually used to save/load a tween to/from a text file.
  bool isValueOf(String str) {
    return str == toString();
  }
}

/// Collection of built-in easing equations
///
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
abstract class TweenEquations {
  static final Linear easeNone = Linear.easeInOut;
  static final Quad easeInQuad = Quad.easeIn;
  static final Quad easeOutQuad = Quad.easeOut;
  static final Quad easeInOutQuad = Quad.easeInOut;
  static final Cubic easeInCubic = Cubic.easeIn;
  static final Cubic easeOutCubic = Cubic.easeOut;
  static final Cubic easeInOutCubic = Cubic.easeInOut;
  static final Quart easeInQuart = Quart.easeIn;
  static final Quart easeOutQuart = Quart.easeOut;
  static final Quart easeInOutQuart = Quart.easeInOut;
  static final Quint easeInQuint = Quint.easeIn;
  static final Quint easeOutQuint = Quint.easeOut;
  static final Quint easeInOutQuint = Quint.easeInOut;
  static final Circ easeInCirc = Circ.easeIn;
  static final Circ easeOutCirc = Circ.easeOut;
  static final Circ easeInOutCirc = Circ.easeInOut;
  static final Sine easeInSine = Sine.easeIn;
  static final Sine easeOutSine = Sine.easeOut;
  static final Sine easeInOutSine = Sine.easeInOut;
  static final Expo easeInExpo = Expo.easeIn;
  static final Expo easeOutExpo = Expo.easeOut;
  static final Expo easeInOutExpo = Expo.easeInOut;
  static final Back easeInBack = Back.easeIn;
  static final Back easeOutBack = Back.easeOut;
  static final Back easeInOutBack = Back.easeInOut;
  static final Bounce easeInBounce = Bounce.easeIn;
  static final Bounce easeOutBounce = Bounce.easeOut;
  static final Bounce easeInOutBounce = Bounce.easeInOut;
  static final Elastic easeInElastic = Elastic.easeIn;
  static final Elastic easeOutElastic = Elastic.easeOut;
  static final Elastic easeInOutElastic = Elastic.easeInOut;
}
