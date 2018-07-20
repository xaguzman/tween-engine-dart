part of tweenengine;

/// TweenCallbacks are used to trigger actions at some specific times.
/// They are used in both Tweens and Timelines.
/// The moment when the callback is triggered depends on its registered triggers:
///
/// * [TweenCallback.begin]: right after the delay (if any)
/// * [TweenCallback.start]: at each iteration beginning
/// * [TweenCallback.end]: at each iteration ending, before the repeat delay
/// * [TweenCallback.complete]: at last END event
/// * [TweenCallback.backBegin]: at the beginning of the first backward iteration
/// * [TweenCallback.backStart]: at each backward iteration beginning, after the repeat delay
/// * [TweenCallback.backEnd]: at each backward iteration ending
/// * [TweenCallback.backComplete]: at last BACK_END event
///
/// forward :      begin                                   complete
/// forward :      start    end      start    end      start    end
/// |--------------[XXXXXXXXXX]------[XXXXXXXXXX]------[XXXXXXXXXX]
/// backward:      bEnd  bStart      bEnd  bStart      bEnd  bStart
/// backward:      bComplete                                 bBegin
///
/// see [Tween]
/// see [Timeline]
/// author
///    Aurelien Ribon | http://www.aurelienribon.com/ (Original java code)
///    Xavier Guzman (dart port)
class TweenCallback {
  TweenCallback._();

  static const int begin = 0x01;
  static const int start = 0x02;
  static const int end = 0x04;
  static const int complete = 0x08;
  static const int backBegin = 0x10;
  static const int backStart = 0x20;
  static const int backEnd = 0x40;
  static const int backComplete = 0x80;
  static const int anyForward = 0x0F;
  static const int anyBackward = 0xF0;
  static const int any = 0xFF;
}

///a handler which can take actions when any event occurs on a tween
typedef void TweenCallbackHandler(int type, BaseTween source);
