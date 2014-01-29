part of tweenengine;

/**
 * TweenCallbacks are used to trigger actions at some specific times. They are
 * used in both Tweens and Timelines. The moment when the callback is
 * triggered depends on its registered triggers:
 * <p/>
 *
 * <b>BEGIN</b>: right after the delay (if any)<br/>
 * <b>START</b>: at each iteration beginning<br/>
 * <b>END</b>: at each iteration ending, before the repeat delay<br/>
 * <b>COMPLETE</b>: at last END event<br/>
 * <b>BACK_BEGIN</b>: at the beginning of the first backward iteration<br/>
 * <b>BACK_START</b>: at each backward iteration beginning, after the repeat delay<br/>
 * <b>BACK_END</b>: at each backward iteration ending<br/>
 * <b>BACK_COMPLETE</b>: at last BACK_END event
 * <p/>
 *
 * <pre> {@code
 * forward :      BEGIN                                   COMPLETE
 * forward :      START    END      START    END      START    END
 * |--------------[XXXXXXXXXX]------[XXXXXXXXXX]------[XXXXXXXXXX]
 * backward:      bEND  bSTART      bEND  bSTART      bEND  bSTART
 * backward:      bCOMPLETE                                 bBEGIN
 * }</pre>
 *
 * @see Tween
 * @see Timeline
 * @author Aurelien Ribon | http://www.aurelienribon.com/
 */
class TweenCallback {
    static const int BEGIN = 0x01;
    static const int START = 0x02;
    static const int END = 0x04;
    static const int COMPLETE = 0x08;
    static const int BACK_BEGIN = 0x10;
    static const int BACK_START = 0x20;
    static const int BACK_END = 0x40;
    static const int BACK_COMPLETE = 0x80;
    static const int ANY_FORWARD = 0x0F;
    static const int ANY_BACKWARD = 0xF0;
    static const int ANY = 0xFF;

    CallbackHandler onEvent;
}

typedef void CallbackHandler(int type, BaseTween source);