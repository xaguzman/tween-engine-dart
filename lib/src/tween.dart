part of tweenengine;

/// Core class of the Tween Engine. A Tween is basically an interpolation
/// between two values of an object attribute. However, the main interest of a
/// Tween is that you can apply an easing formula on this interpolation, in
/// order to smooth the transitions or to achieve cool effects like springs or
/// bounces.
///
/// This class contains many factory methods to create and instantiate
/// new interpolations easily(all tweens are pooled). The common way to create a Tween is by using one
/// of these factories:
///
/// * new Tween.to(...)
/// * new Tween.from(...)
/// * new Tween.set(...)
/// * new Tween.callBack(...)
///
/// Tween life-cycles can be automatically managed for you, thanks to the
/// [TweenManager] class. If you choose to manage your tween when you start
/// it, then you don't need to care about it anymore. **Tweens are
/// _fire-and-forget_: don't think about them anymore once you started
/// them (if they are managed of course).**
///
/// You need to periodicaly update the tween engine, in order to compute the new
/// values. If your tweens are managed, only update the manager; else you need
/// to call [:update():] on your tweens periodically.
///
/// The engine cannot directly change your objects attributes, since it doesn't
/// know them. Therefore, you need to let it know how to get and set the different
/// attributes of your objects: **you need to implement the [TweenAccessor]
/// interface for each object class you will animate**. If you have direct control of the classes
/// you want to animate, you can instead implement the [Tweenable] interface. Once
/// done, don't forget to register these implementations, using the static method
/// [registerAccessor] (only for TweenAccessors), when you start your application.
///
/// see also [TweenAccessor]
/// see also [Tweenable]
/// see also [TweenManager]
/// see also [Timeline]
///
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Tween extends BaseTween {
  // -------------------------------------------------------------------------
  // Static -- misc
  // -------------------------------------------------------------------------

  ///Used as parameter in [repeat] and [repeatYoyo] methods.
  static const int infinity = -1;

  static int _combinedAttrsLimit = 3;
  static int _waypointsLimit = 0;

  ///Changes the [limit] for combined attributes. Defaults to 3 to reduce memory footprint.
  static set combinedAttributesLimit(int limit) {
    Tween._combinedAttrsLimit = limit;
  }

  ///Changes the [limit] of allowed waypoints for each tween. Defaults to 0 to reduce memory footprint.
  static set waypointsLimit(int limit) {
    Tween._waypointsLimit = limit;
  }

  ///Gets the version number of the library.
  static String get version => "0.11.1";

  // -------------------------------------------------------------------------
  // Static -- pool
  // -------------------------------------------------------------------------

  static final PoolCallback<Tween> _poolCallback = PoolCallback<Tween>()
    ..onPool = (Tween obj) {
      obj.reset();
    }
    ..onUnPool = (Tween obj) {
      obj.reset();
    };

  static final Pool<Tween> _pool = Pool<Tween>(_poolCallback)
    ..create = () => Tween._();

  /// Used for debug purpose. Gets the current number of objects that are waiting in the Tween pool.
  int getPoolSize() => _pool.size();

  //Increases the minimum capacity of the pool. Capacity defaults to 20.
  //static void ensurePoolCapacity(int minCapacity) => _pool.ensureCapacity(minCapacity);

  // -------------------------------------------------------------------------
  // Static -- tween accessors
  // -------------------------------------------------------------------------

  static final Map<Type, TweenAccessor> _registeredAccessors =
      Map<Type, TweenAccessor>();

  /// Registers an accessor with the class of an object. This accessor will be
  /// used by tweens applied to every objects implementing the registered
  /// class, or inheriting from it.
  ///
  /// [someType] An object type.
  /// [defaultAccessor] Th e accessor that will be used to tween any object of class "someClass".
  static void registerAccessor(Type someType, TweenAccessor defaultAccessor) {
    _registeredAccessors[someType] = defaultAccessor;
  }

  /// Gets the registered TweenAccessor associated with the given object class.
  ///
  /// [someType] An object type.
  static TweenAccessor getRegisteredAccessor(Type someType) {
    return _registeredAccessors[someType];
  }

  // -------------------------------------------------------------------------
  // Static -- factories
  // -------------------------------------------------------------------------

  /// Factory creating a new standard interpolation. This is the most common
  /// type of interpolation. The starting values are retrieved automatically
  /// after the delay (if any).
  ///
  /// **You need to set the target values of the interpolation by using
  /// the [targetValues] or [targetRelative] setter**. The interpolation will run from the
  /// starting values to these target values.
  ///
  /// The common use of Tweens is "fire-and-forget": you do not need to care
  /// for tweens once you added them to a TweenManager, they will be updated
  /// automatically, and cleaned once finished. Common call:
  ///
  ///     new Tween.to(myObject, POSITION, 1.0f)
  ///       ..targetValues = [50, 70]
  ///       ..easing = Quad.INOUT
  ///       ..start(myManager);
  ///
  /// Several options such as delay, repetitions and callbacks can be added to
  /// the tween.
  ///
  /// [target] The target object of the interpolation.
  /// [tweenType] The desired type of interpolation.
  /// [duration] The duration of the interpolation, in milliseconds.
  ///
  /// Returns The generated Tween.
  factory Tween.to(Object target, int tweenType, num duration) {
    Tween tween = _pool.get()
      ..easing = TweenEquations.easeInOutQuad
      .._setup(target, tweenType, duration)
      ..path = TweenPaths.catmullRom;
    return tween;
  }

  /// Factory creating a new reversed interpolation. The ending values are
  /// retrieved automatically after the delay (if any).
  ///
  /// **You need to set the starting values of the interpolation by using
  /// the [targetValues] or [targetRelative] setter**. The interpolation will run from the
  /// starting values to these target values.
  ///
  /// The common use of Tweens is "fire-and-forget": you do not need to care
  /// for tweens once you added them to a TweenManager, they will be updated
  /// automatically, and cleaned once finished. Common call:
  ///
  ///     new Tween.from(myObject, POSITION, 1.0)
  ///      ..targetValues = [0, 0]
  ///      ..easing = Quad.INOUT
  ///      .start(myManager);
  ///
  /// Several options such as delay, repetitions and callbacks can be added to
  /// the tween.
  ///
  /// [target] The target object of the interpolation.
  /// [tweenType] The desired type of interpolation.
  /// [duration] The duration of the interpolation, in milliseconds.
  ///
  /// Returns The generated Tween.
  factory Tween.from(Object target, int tweenType, num duration) {
    Tween tween = _pool.get()
      .._setup(target, tweenType, duration)
      ..easing = TweenEquations.easeInOutQuad
      ..path = TweenPaths.catmullRom
      .._isFrom = true;
    return tween;
  }

  /// Factory creating a new instantaneous interpolation (thus this is not
  /// really an interpolation).
  ///
  /// **You need to set the target values of the interpolation by using
  /// the [targetValues] or [targetRelative] setter**. The interpolation will set the target
  /// attribute to these values after the delay (if any).
  ///
  /// The common use of Tweens is "fire-and-forget": you do not need to care
  /// for tweens once you added them to a TweenManager, they will be updated
  /// automatically, and cleaned once finished. Common call:
  ///
  ///     new Tween.set(myObject, POSITION)
  ///      ..target = [50, 70]
  ///      ..delay = 1
  ///      ..start(myManager);
  ///
  /// Several options such as delay, repetitions and callbacks can be added to
  /// the tween.
  ///
  /// [target] The target object of the interpolation.
  /// [tweenType] The desired type of interpolation.
  ///
  /// Returns The generated Tween.
  factory Tween.set(Object target, int tweenType) {
    Tween tween = _pool.get()
      .._setup(target, tweenType, 0)
      ..easing = TweenEquations.easeInQuad;
    return tween;
  }

  /// Factory creating a new timer. The given callback will be triggered on
  /// each iteration start, after the delay.
  ///
  /// The common use of Tweens is "fire-and-forget": you do not need to care
  /// for tweens once you added them to a TweenManager, they will be updated
  /// automatically, and cleaned once finished. Common call:
  ///
  ///     new Tween.call(myCallback)
  ///      ..delay = 1
  ///      ..repeat(10, 1000)
  ///      ..start(myManager);
  ///
  /// see [TweenCallback]
  ///
  /// [callback] the function that will be triggered on each iteration start.
  ///
  /// Returns The generated Tween.
  factory Tween.call(TweenCallbackHandler callback) {
    Tween tween = _pool.get()
      .._setup(null, -1, 0)
      ..callback = callback
      ..callbackTriggers = TweenCallback.start;
    return tween;
  }

  /// Convenience method to create an empty tween. Such object is only useful
  /// when placed inside animation sequences (see [Timeline]), in which
  /// it may act as a beacon, so you can set a callback on it in order to
  /// trigger some action at the right moment.
  ///
  /// Returns The generated Tween.
  factory Tween.mark() {
    Tween tween = _pool.get().._setup(null, -1, 0);
    return tween;
  }

  // -------------------------------------------------------------------------
  // Attributes
  // -------------------------------------------------------------------------

  // Main
  Object _target;
  Type _targetClass;
  TweenAccessor<Object> _accessor;
  int _type;

  /// The easing [equation][TweenEquation] of the tween. Existing equations can be accessed via
  /// [TweenEquations] static instances, but you can of course implement your owns, see [TweenEquation].
  /// Default equation is Quad.INOUT.
  TweenEquation easing;

  /// The algorithm that will be used to navigate through the waypoints,
  /// from the start values to the end values. Default is a catmull-rom spline,
  /// but you can find other paths in the [TweenPaths] class.
  TweenPath path;

  // General
  bool _isFrom;
  bool _isRelative;
  int _combinedAttrsCnt;
  int _waypointsCnt;

  // Values
  final List<num> _startValues = List<num>(_combinedAttrsLimit);
  final List<num> _targetValues = List<num>(_combinedAttrsLimit);
  final List<num> _waypoints = List<num>(_waypointsLimit * _combinedAttrsLimit);

  // Buffers
  List<num> _accessorBuffer = List<num>(_combinedAttrsLimit);
  List<num> _pathBuffer =
      List<num>((2 + _waypointsLimit) * _combinedAttrsLimit);

  // -------------------------------------------------------------------------
  // Setup
  // -------------------------------------------------------------------------

  Tween._() {
    reset();
  }

  //@Override
  void reset() {
    super.reset();

    _target = null;
    _targetClass = null;
    _accessor = null;
    _type = -1;
    easing = null;
    path = null;

    _isFrom = _isRelative = false;
    _combinedAttrsCnt = _waypointsCnt = 0;

    if (_accessorBuffer.length != _combinedAttrsLimit) {
      _accessorBuffer = Float32List(_combinedAttrsLimit);
    }

    if (_pathBuffer.length != (2 + _waypointsLimit) * _combinedAttrsLimit) {
      _pathBuffer = Float32List((2 + _waypointsLimit) * _combinedAttrsLimit);
    }
  }

  void _setup(Object target, int tweenType, num duration) {
    if (duration < 0) throw Exception("Duration can't be negative");

    _target = target;
    _targetClass = target != null ? _findTargetClass() : null;
    _type = tweenType;
    duration = duration;
  }

  Type _findTargetClass() {
    if (_registeredAccessors.containsKey(_target.runtimeType))
      return _target.runtimeType;
    if (_target is TweenAccessor) return _target.runtimeType;
    if (_target is Tweenable) return _target.runtimeType;

    //TODO: accesing parent Type's is not suported yet in dart without reflection, implement it once it does
//                Type parentClass = _target.runtimeType.getSuperclass();
//                while (parentClass != null && !_registeredAccessors.containsKey(parentClass))
//                        parentClass = parentClass.getSuperclass();
//
//                return parentClass;
    return null;
  }

  // -------------------------------------------------------------------------
  // API
  // -------------------------------------------------------------------------

  /// Forces the tween to use the TweenAccessor registered with the given target class. Useful if you want to use a specific accessor associated
  /// to an interface, for instance.
  ///
  /// [targetClass] A type registered with an accessor.
  void cast(Type targetClass) {
    if (isStarted)
      throw Exception(
          "You can't cast the target of a tween once it is started");
    _targetClass = targetClass;
  }

  /// Adds a waypoint to the path. The default path runs from the start values
  /// to the end values linearly. If you add waypoints, the default path will
  /// use a smooth catmull-rom spline to navigate between the waypoints, but
  /// you can change this behavior by setting the [path].
  ///
  /// [num_OR_numList] The targets of this waypoint. Can be either a num, or a List<num>
  void addWaypoint(num_OR_numList) {
    if (num_OR_numList is num) {
      if (_waypointsCnt == _waypointsLimit) _throwWaypointsLimitReached();
      _waypoints[_waypointsCnt] = num_OR_numList;
      _waypointsCnt += 1;
    } else if (num_OR_numList is List<num>) {
      if (_waypointsCnt == _waypointsLimit) _throwWaypointsLimitReached();
      _waypoints.setAll(_waypointsCnt * num_OR_numList.length, num_OR_numList);
      _waypointsCnt += 1;
    }
  }

  // -------------------------------------------------------------------------
  // Getters & Setters
  // -------------------------------------------------------------------------

  ///Gets the target object.
  get target => _target;

  ///Gets the type of the tween.
  int get tweenType => _type;

  /// Target value(s) of the interpolation. The interpolation will run from the
  /// **value(s) at start time (after the delay, if any)** to these target value(s).
  ///
  /// To sum-up:
  /// * start values: values at start time, after delay
  /// * end values: [num_OR_numList]
  ///
  /// [num_OR_numList] The target values of the interpolation. Can be either a num, or a List<num> if
  /// multiple target values are needed
  List<num> get targetValues => _targetValues;
  set targetValues(List<num> values) {
    if (_targetValues.length > _combinedAttrsLimit)
      _throwCombinedAttrsLimitReached();
    _targetValues.setAll(0, values);
  }

  /// Sets the target values of the interpolation, relatively to the **values
  /// at start time (after the delay, if any)**.
  ///
  /// To sum-up:<br/>
  /// - start values: values at start time, after delay
  /// - end values: params + values at start time, after delay
  ///
  /// [values] The relative target values of the interpolation. Can be either a num, or a List<num> if
  /// multiple target values are needed
  set targetRelative(List<num> values) {
    if (values.length > _combinedAttrsLimit) _throwCombinedAttrsLimitReached();
    for (int i = 0; i < values.length; i++) {
      _targetValues[i] =
          isInitialized ? values[i] + _startValues[i] : values[i];
    }
    _isRelative = true;
  }

  ///the number of combined animations.
  int get combinedAttributesCount => _combinedAttrsCnt;

  ///the TweenAccessor used with the target.
  TweenAccessor get accessor => _accessor;

  ///the class that was used to find the associated TweenAccessor.
  Type get targetClass => _targetClass;

  // -------------------------------------------------------------------------
  // Overrides
  // -------------------------------------------------------------------------

  void build() {
    if (_target == null) return;

    _accessor = _registeredAccessors[_targetClass];
    if (_accessor == null && _target is TweenAccessor) _accessor = _target;
    if (_accessor != null) {
      _combinedAttrsCnt =
          _accessor.getValues(_target, this, _type, _accessorBuffer);
      if (_combinedAttrsCnt == null) _combinedAttrsCnt = 0;
    } else if (_target is Tweenable) {
      _combinedAttrsCnt = (_target as Tweenable)
          .getTweenableValues(this, _type, _accessorBuffer);
      if (_combinedAttrsCnt == null) _combinedAttrsCnt = 0;
    } else
      throw Exception(
          "No TweenAccessor was found for the target, and it is not Tweenable either.");

    if (_combinedAttrsCnt > _combinedAttrsLimit)
      _throwCombinedAttrsLimitReached();
  }

  void free() {
    _pool.free(this);
  }

  void initializeOverride() {
    if (_target == null) return;

    _getTweenedValues(_startValues);

    for (int i = 0; i < _combinedAttrsCnt; i++) {
      _targetValues[i] += _isRelative ? _startValues[i] : 0;

      for (int ii = 0; ii < _waypointsCnt; ii++) {
        _waypoints[ii * _combinedAttrsCnt + i] +=
            _isRelative ? _startValues[i] : 0;
      }

      if (_isFrom) {
        num tmp = _startValues[i];
        _startValues[i] = _targetValues[i];
        _targetValues[i] = tmp;
      }
    }
  }

  void updateOverride(int step, int lastStep, bool isIterationStep, num delta) {
    if (_target == null || easing == null) return;

    // Case iteration end has been reached
    if (!isIterationStep && step > lastStep) {
      _setTweenedValues(isReverse(lastStep) ? _startValues : _targetValues);
      return;
    }

    if (!isIterationStep && step < lastStep) {
      _setTweenedValues(isReverse(lastStep) ? _targetValues : _startValues);
      return;
    }

    // Validation
    assert(isIterationStep);
    assert(currentTime >= 0);
    assert(currentTime <= duration);

    // Case duration equals zero
    if (duration < 0.00000000001 && delta > -0.00000000001) {
      _setTweenedValues(isReverse(step) ? _targetValues : _startValues);
      return;
    }

    if (duration < 0.00000000001 && delta < 0.00000000001) {
      _setTweenedValues(isReverse(step) ? _startValues : _targetValues);
      return;
    }

    // Normal behavior
    num time = isReverse(step) ? duration - currentTime : currentTime;
    num t = easing.compute(time / duration);

    if (_waypointsCnt == 0 || path == null) {
      for (int i = 0; i < _combinedAttrsCnt; i++) {
        _accessorBuffer[i] =
            _startValues[i] + t * (_targetValues[i] - _startValues[i]);
      }
    } else {
      for (int i = 0; i < _combinedAttrsCnt; i++) {
        _pathBuffer[0] = _startValues[i];
        _pathBuffer[1 + _waypointsCnt] = _targetValues[i];
        for (int ii = 0; ii < _waypointsCnt; ii++) {
          _pathBuffer[ii + 1] = _waypoints[ii * _combinedAttrsCnt + i];
        }

        _accessorBuffer[i] = path.compute(t, _pathBuffer, _waypointsCnt + 2);
      }
    }

    _setTweenedValues(_accessorBuffer);
  }

  // -------------------------------------------------------------------------
  // BaseTween impl.
  // -------------------------------------------------------------------------

  void forceStartValues() {
    if (_target == null) return;
    _setTweenedValues(_startValues);
  }

  void forceEndValues() {
    if (_target == null) return;
    _setTweenedValues(_targetValues);
  }

  bool containsTarget(Object target, [int tweenType = null]) {
    if (tweenType == null) return _target == target;
    return _target == target && _type == tweenType;
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  int _getTweenedValues(intoBuffer) {
    if (_accessor != null) {
      return _accessor.getValues(_target, this, _type, intoBuffer);
    } else if (_target is Tweenable) {
      // _target is Tweenable
      return (_target as Tweenable).getTweenableValues(this, _type, intoBuffer);
    }

    return 0;
  }

  void _setTweenedValues(values) {
    if (_accessor != null) {
      _accessor.setValues(_target, this, _type, values);
    } else if (_target is Tweenable) {
      (_target as Tweenable).setTweenableValues(this, _type, values);
    }
  }

  void _throwCombinedAttrsLimitReached() {
    String msg = """You cannot combine more than $_combinedAttrsLimit 
                  attributes in a tween. You can raise this limit with 
                  Tween.setCombinedAttributesLimit(), which should be called once
                  in application initialization code.""";
    throw Exception(msg);
  }

  void _throwWaypointsLimitReached() {
    String msg = """You cannot add more than $_waypointsLimit 
                  waypoints to a tween. You can raise this limit with
                  Tween.setWaypointsLimit(), which should be called once in
                  application initialization code.""";
    throw Exception(msg);
  }
}
