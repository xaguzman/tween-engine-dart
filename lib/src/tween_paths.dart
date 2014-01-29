part of tweenengine;

typedef num PathComputingFunction(num t, Float32List points, int pointsCnt);

/**
 * Base class for every paths. You can create your own paths and directly use
 * them in the Tween engine by inheriting from this class.
 *
 * @author Aurelien Ribon | http://www.aurelienribon.com/
 */
abstract class TweenPath {

  /**
   * Computes the next value of the interpolation, based on its waypoints and
   * the current progress.
   *
   * @param t The progress of the interpolation, between 0 and 1. May be out
   * of these bounds if the easing equation involves some kind of rebounds.
   * @param points The waypoints of the tween, from start to target values.
   * @param pointsCnt The number of valid points in the array.
   * @return The next value of the interpolation.
   */
  PathComputingFunction compute;
}


/**
 * Collection of built-in paths.
 *
 * @author Aurelien Ribon | http://www.aurelienribon.com/
 */
abstract class TweenPaths {
  static final LinearPath linear = new LinearPath();
  static final CatmullRom catmullRom = new CatmullRom();
}