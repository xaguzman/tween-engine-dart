part of tweenengine;

/**
 * Easing equation based on Robert Penner's work:
 * http://robertpenner.com/easing/
 * @author Aurelien Ribon | http://www.aurelienribon.com/
 */
class Linear extends TweenEquation {
  
  static final Linear INOUT = new Linear._()
    ..name = "Linear.INOUT"
    ..compute = (num t) => t;
  
  Linear._();
}