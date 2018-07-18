part of tweenengine;

/// A Timeline is a container for many tweens, which can be played either sequentially, or in parallel.
/// A timeline can contain other timelines as well.
///
/// The following example will create an animation sequence composed of 5 parts:
///
/// 1. First, opacity and scale are set to 0 (with Tween.set() calls).
/// 2. Then, opacity and scale are animated in parallel.
/// 3. Then, the animation is paused for 1s.
/// 4. Then, position is animated to x=100.
/// 5. Then, rotation is animated to 360°.
///
/// This animation will be repeated 5 times, with a 500ms delay between each
/// iteration:
///
///     new Timeline.sequence()
///       ..push(new Tween.set(myObject, OPACITY).target(0))
///       ..push(new Tween.set(myObject, SCALE).target(0, 0))
///       ..beginParallel()
///         ..push(new Tween.to(myObject, OPACITY, 0.5)
///           ..targetValues = 1
///           ..easing = Quad.INOUT)
///         ..push(new Tween.to(myObject, SCALE, 0.5)
///           ..targetValues = [1, 1]
///           ..easing = Quad.INOUT)
///      ..end()
///      ..pushPause(1.0)
///      ..push(new Tween.to(myObject, POSITION_X, 0.5)
///        ..targetValues = 100
///        ..easing = Quad.INOUT)
///      ..push(new Tween.to(myObject, ROTATION, 0.5)
///        ..targetValues = 360
///        ..easing = Quad.INOUT)
///      ..repeat(5, 0.5)
///      ..start(myManager);
///
/// see [Tween]
/// see [TweenManager]
/// see [TweenCallback]
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class Timeline extends BaseTween {
  // -------------------------------------------------------------------------
  // Static -- pool
  // -------------------------------------------------------------------------

  static final PoolCallback<Timeline> _poolCallback = PoolCallback<Timeline>()
    ..onPool = (Timeline obj) {
      obj.reset();
    }
    ..onUnPool = (Timeline obj) {
      obj.reset();
    };

  static final Pool<Timeline> _pool = Pool<Timeline>(_poolCallback)
    ..create = () => Timeline._();

  // -------------------------------------------------------------------------
  // Static -- factories
  // -------------------------------------------------------------------------

  /// Creates a new timeline with a 'sequence' behavior. Its children will be delayed so that they are triggered one after the other.
  factory Timeline.sequence() {
    Timeline tl = _pool.get();
    tl._setup(TimelineMode.sequence);
    return tl;
  }

  ///Creates a new timeline with a 'parallel' behavior. Its children will be triggered all at once.
  factory Timeline.parallel() {
    Timeline tl = _pool.get();
    tl._setup(TimelineMode.parallel);
    return tl;
  }

  Timeline._() {
    reset();
  }

  ///Used for debug purpose. Gets the current number of empty timelines that are waiting in the Timeline pool.
  static int get poolSize => _pool.size();

  ///Increases the minimum capacity of the pool. Capacity defaults to 10.
  static void ensurePoolCapacity(int minCapacity) {
    _pool.ensureCapacity(minCapacity);
  }

  // -------------------------------------------------------------------------
  // Attributes
  // -------------------------------------------------------------------------
  final List<BaseTween> _children = List<BaseTween>();
  Timeline _current;
  Timeline _parent;
  int _mode;
  bool _isBuilt;

  // -------------------------------------------------------------------------
  // Setup
  // -------------------------------------------------------------------------

  void reset() {
    super.reset();

    _children.clear();
    _current = _parent = null;

    _isBuilt = false;
  }

  void _setup(int mode) {
    _mode = mode;
    _current = this;
  }

  // -------------------------------------------------------------------------
  // API
  // -------------------------------------------------------------------------

  ///Adds a Tween or nests a Timeline to the current timeline
  void push(BaseTween tweenOrTimeline) {
    if (tweenOrTimeline is! Tween && tweenOrTimeline is! Timeline)
      throw Exception("Only a tween or timeline can be pushed into a timeline");

    if (_isBuilt)
      throw Exception(
          "You can't push anything to a timeline once it is started");

    if (tweenOrTimeline is Tween)
      _pushTween(tweenOrTimeline);
    else
      _pushTimeline(tweenOrTimeline);
  }

  ///Adds a Tween to the current timeline.
  void _pushTween(Tween tween) {
    _current._children.add(tween);
  }

  /// Nests a Timeline in the current one.
  void _pushTimeline(Timeline timeline) {
    if (timeline._current != timeline)
      throw Exception(
          "You forgot to call a few 'end()' statements in your pushed timeline");
    timeline._parent = _current;
    _current._children.add(timeline);
  }

  /// Adds a pause to the timeline. The pause may be negative if you want to overlap the preceding and following children.
  ///
  /// [time] A positive or negative duration.
  void pushPause(num time) {
    if (_isBuilt)
      throw Exception(
          "You can't push anything to a timeline once it is started");
    _current._children.add(Tween.mark()..delay = time);
  }

  ///Starts a nested timeline with a 'sequence' behavior. Don't forget to call [end] to close this nested timeline.
  void beginSequence() {
    if (_isBuilt)
      throw Exception(
          "You can't push anything to a timeline once it is started");
    Timeline tl = _pool.get();
    tl._parent = _current;
    tl._mode = TimelineMode.sequence;
    _current._children.add(tl);
    _current = tl;
  }

  ///Starts a nested timeline with a 'parallel' behavior. Don't forget to call {@link end()} to close this nested timeline.
  void beginParallel() {
    if (_isBuilt)
      throw Exception(
          "You can't push anything to a timeline once it is started");
    Timeline tl = _pool.get();
    tl._parent = _current;
    tl._mode = TimelineMode.parallel;
    _current._children.add(tl);
    _current = tl;
  }

  ///Closes the last nested timeline.
  void end() {
    if (_isBuilt)
      throw Exception(
          "You can't push anything to a timeline once it is started");
    if (_current == this) throw Exception("Nothing to end...");
    _current = _current._parent;
  }

  ///Gets a list of the timeline children. If the timeline is started, the list will be immutable.
  List<BaseTween> getChildren() {
    if (_isBuilt)
      return List<BaseTween>.from(_current._children, growable: false);
    else
      return _current._children;
  }

  // -------------------------------------------------------------------------
  // Overrides
  // -------------------------------------------------------------------------

  void build() {
    if (_isBuilt) return;

    duration = 0;

    for (int i = 0; i < _children.length; i++) {
      BaseTween obj = _children[i];

      if (obj.repeatCount < 0)
        throw Exception(
            "You can't push an object with infinite repetitions in a timeline");
      obj.build();

      switch (_mode) {
        case TimelineMode.sequence:
          num tDelay = duration;
          duration += obj.fullDuration;
          obj.delay += tDelay;
          break;

        case TimelineMode.parallel:
          duration = math.max(duration, obj.fullDuration);
          break;
      }
    }

    _isBuilt = true;
  }

  void start([TweenManager manager]) {
    super.start(manager);
    if (manager == null) {
      _children.forEach((BaseTween tween) => tween.start());
    }
  }

  void free() {
    _children.forEach((BaseTween tween) => tween.free());
    _children.clear();
    _pool.free(this);
  }

  void updateOverride(int step, int lastStep, bool isIterationStep, num delta) {
    if (!isIterationStep && step > lastStep) {
      assert(delta >= 0);
      num dt = isReverse(lastStep) ? -delta - 1 : delta + 1;
      _children.forEach((BaseTween tween) => tween.update(dt));
      return;
    }

    if (!isIterationStep && step < lastStep) {
      assert(delta <= 0);
      num dt = isReverse(lastStep) ? delta + 1 : -delta - 1;
      _children.reversed.forEach((BaseTween tween) => tween.update(dt));
      return;
    }

    assert(isIterationStep);

    if (step > lastStep) {
      if (isReverse(step)) {
        forceEndValues();
        _children.reversed.forEach((BaseTween tween) => tween.update(delta));
      } else {
        forceStartValues();
        _children.forEach((BaseTween tween) => tween.update(delta));
      }
    } else if (step < lastStep) {
      if (isReverse(step)) {
        forceStartValues();
        _children.reversed.forEach((BaseTween tween) => tween.update(delta));
      } else {
        forceEndValues();
        _children.reversed.forEach((BaseTween tween) => tween.update(delta));
      }
    } else {
      num dt = isReverse(step) ? -delta : delta;
      if (delta >= 0)
        _children.forEach((BaseTween tween) => tween.update(dt));
      else
        _children.reversed.forEach((BaseTween tween) => tween.update(dt));
    }
  }

  // -------------------------------------------------------------------------
  // BaseTween impl.
  // -------------------------------------------------------------------------

  void forceStartValues() {
    _children.forEach((BaseTween tween) => tween.forceToStart());
  }

  void forceEndValues() {
    _children.forEach((BaseTween tween) => tween.forceToEnd(duration));
  }

  bool containsTarget(Object target, [int tweenType]) {
    return _children
        .any((BaseTween tween) => tween.containsTarget(target, tweenType));
  }
}

class TimelineMode {
  static const int sequence = 1, parallel = 2;
}
