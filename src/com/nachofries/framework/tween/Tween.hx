package com.nachofries.framework.tween;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;

@final
class Tween {
    public var easing:Easing;
    public var duration:Int;
    public var repeatTimes:Int;
    public var autoReverse:Bool;
    public var backwards:Bool;
    public var inverse:Bool;

    public var delay:Int;
    public var endDelay:Int;

    private var currentTime:Int;
    public var currentRepeat:Int;

    public static inline function create(easing:Easing, duration:Int=100, autoReverse:Bool = false, repeat:Int = 0, delay:Int=0, endDelay:Int=0):Tween {
        var item:Tween = Pooling.get(ClassInfo.getClassName());
        if(item == null) {
            item = new Tween();
        }
        item.init(easing, duration, autoReverse, repeat, delay, endDelay);
        return item;
    }
    private function new() {}
    private function init(easing:Easing, duration:Int=100, autoReverse:Bool=false, repeatTimes:Int=0, delay:Int=0, endDelay:Int=0) {
        if(autoReverse && repeatTimes == 0) {
            repeatTimes = 1;
        }
        this.easing = easing;
        this.duration = duration;
        this.repeatTimes = repeatTimes;
        this.autoReverse = autoReverse;

        this.delay = delay;
        this.endDelay = endDelay;
        reset();
    }

    public function setRepeat(repeatTimes:Int=-1, autoReverse:Bool=true):Void {
        this.repeatTimes = repeatTimes;
        currentRepeat = repeatTimes;
        this.autoReverse = autoReverse;
    }

    public function reset():Void {
        currentRepeat = repeatTimes;
        backwards = false;
        inverse = false;
        currentTime = 0;
    }

    public function tick():Float {
        if(delay != 0) {
            delay--;
        } else if(endDelay != 0 && getPercent() == 1) {
            endDelay--;
        } else {
            backwards ? currentTime-- : currentTime++;
            if(isFinished() && (currentRepeat == -1 || currentRepeat > 0)) {
                if(autoReverse) {
                    backwards = !backwards;
                } else {
                    reset();
                }
                if(currentRepeat > 0) {
                    currentRepeat--;
                }
            }
        }
        return getValue();
    }

    public function getPercent():Float {
        return 1. * currentTime / duration;
    }

    public function reverse():Void {
        currentTime = duration;
        backwards = true;
    }

    public function destroy():Void {
        Pooling.recycle(this);
    }

    public function isFinished():Bool {
        return delay == 0 && endDelay == 0 && (backwards ? currentTime <= 0 : currentTime >= duration);
    }

    public function getValue():Float {
        return getTweenValue(easing);
    }

    public inline function getTweenValue(transitionType:Easing):Float {
        var valuePercent = getTweenValuePercent(transitionType, getPercent());
        return inverse ? 1 - valuePercent : valuePercent;
    }

    static inline function getTweenValuePercent(transitionType:Easing, percent:Float):Float {
        return switch(transitionType) {
            case LINEAR: percent;
            case SINOIDAL: (-Math.cos(percent * Math.PI) * .5) + .5;
            case SINOIDAL_PERIOD(period): Math.sin(percent * Math.PI * period);
            case COSIGN_PERIOD(period): Math.cos(percent * Math.PI * period);
            case REVERSE: 1 - percent;
            case FLICKER:
                percent = ((-Math.cos(percent * Math.PI) / 4) + .75) + Math.random() / 4;
                percent > 1 ? 1 : percent;
            case WOBBLE:(-Math.cos(percent * Math.PI * (9 * percent)) * .5) + .5;
            case PULSE(pulses): (-Math.cos((percent * ((pulses < 0 ? 5 : pulses) - .5) * 2) * Math.PI) * .5) + .5;
            case SPRING: 1 - (Math.cos(percent * 4.5 * Math.PI) * Math.exp(-percent * 6));
            case NONE: 0;
            case FULL: 1;

            case EASE_IN: easeIn(percent);
            case EASE_OUT: easeOut(percent);
            case EASE_IN_OUT: easeInOut(percent);
            case EASE_OUT_IN: easeOutIn(percent);
            case EASE_IN_BACK: easeInBack(percent);
            case EASE_OUT_BACK: easeOutBack(percent);
            case EASE_IN_OUT_BACK: easeInOutBack(percent);
            case EASE_OUT_IN_BACK: easeOutInBack(percent);
            case EASE_IN_ELASTIC: easeInElastic(percent);
            case EASE_OUT_ELASTIC: easeOutElastic(percent);
            case EASE_IN_OUT_ELASTIC: easeInOutElastic(percent);
            case EASE_OUT_IN_ELASTIC: easeOutInElastic(percent);
            case EASE_IN_BOUNCE: easeInBounce(percent);
            case EASE_OUT_BOUNCE: easeOutBounce(percent);
            case EASE_IN_OUT_BOUNCE: easeInOutBounce(percent);
            case EASE_OUT_IN_BOUNCE: easeOutInBounce(percent);


            case QUAD_IN: quadIn(percent);
            case BOUNCE_IN: bounceIn(percent);
            case CIRCLE_IN_OUT: circInOut(percent);
            case EXPO_IN_OUT: expoInOut(percent);
            case BOUNCE_OUT: bounceOut(percent);


        }
    }

    public static function easeIn(percent:Float):Float {
        return percent * percent * percent;
    }

    public static function easeOut(percent:Float):Float {
        var invPercent:Float = percent - 1.0;
        return invPercent * invPercent * invPercent + 1;
    }

    public static function easeInOut(percent:Float):Float {
        return easeCombined(easeIn, easeOut, percent);
    }

    public static function easeOutIn(percent:Float):Float {
        return easeCombined(easeOut, easeIn, percent);
    }

    public static function easeInBack(percent:Float):Float {
        var s:Float = 1.70158;
        return Math.pow(percent, 2) * ((s + 1.0) * percent - s);
    }

    public static function easeOutBack(percent:Float):Float {
        var invPercent:Float = percent - 1.0;
        var s:Float = 1.70158;
        return Math.pow(invPercent, 2) * ((s + 1.0) * invPercent + s) + 1.0;
    }

    public static function easeInOutBack(percent:Float):Float {
        return easeCombined(easeInBack, easeOutBack, percent);
    }

    public static function easeOutInBack(percent:Float):Float {
        return easeCombined(easeOutBack, easeInBack, percent);
    }

    public static function easeInElastic(percent:Float):Float {
        if(percent == 0 || percent == 1) return percent;
        else {
            var p:Float = 0.3;
            var s:Float = p / 4.0;
            var invPercent:Float = percent - 1;
            return -1.0 * Math.pow(2.0, 10.0 * invPercent) * Math.sin((invPercent - s) * (2.0 * Math.PI) / p);
        }
    }

    public static function easeOutElastic(percent:Float):Float {
        if(percent == 0 || percent == 1) return percent;
        else {
            var p:Float = 0.3;
            var s:Float = p / 4.0;
            return Math.pow(2.0, -10.0 * percent) * Math.sin((percent - s) * (2.0 * Math.PI) / p) + 1;
        }
    }

    public static function easeInOutElastic(percent:Float):Float {
        return easeCombined(easeInElastic, easeOutElastic, percent);
    }

    public static function easeOutInElastic(percent:Float):Float {
        return easeCombined(easeOutElastic, easeInElastic, percent);
    }

    public static function easeInBounce(percent:Float):Float {
        return 1.0 - easeOutBounce(1.0 - percent);
    }

    public static function easeOutBounce(percent:Float):Float {
        var s:Float = 7.5625;
        var p:Float = 2.75;
        var l:Float;
        if(percent < (1.0 / p)) {
            l = s * Math.pow(percent, 2);
        }
        else {
            if(percent < (2.0 / p)) {
                percent -= 1.5 / p;
                l = s * Math.pow(percent, 2) + 0.75;
            }
            else {
                if(percent < 2.5 / p) {
                    percent -= 2.25 / p;
                    l = s * Math.pow(percent, 2) + 0.9375;
                }
                else {
                    percent -= 2.625 / p;
                    l = s * Math.pow(percent, 2) + 0.984375;
                }
            }
        }
        return l;
    }

    public static function easeInOutBounce(percent:Float):Float {
        return easeCombined(easeInBounce, easeOutBounce, percent);
    }

    public static function easeOutInBounce(percent:Float):Float {
        return easeCombined(easeOutBounce, easeInBounce, percent);
    }

    public static function easeCombined(startFunc:Float -> Float, endFunc:Float -> Float, percent:Float):Float {
        if(percent < 0.5) return 0.5 * startFunc(percent * 2.0);
        else return 0.5 * endFunc((percent - 0.5) * 2.0) + 0.5;
    }

/** Quadratic in. */

    public static function quadIn(t:Float):Float {
        return t * t;
    }

/** Quadratic out. */

    public static function quadOut(t:Float):Float {
        return -t * (t - 2);
    }

/** Quadratic in and out. */

    public static function quadInOut(t:Float):Float {
        return t <= .5 ? t * t * 2 : 1 - (--t) * t * 2;
    }

/** Cubic in. */

    public static function cubeIn(t:Float):Float {
        return t * t * t;
    }

/** Cubic out. */

    public static function cubeOut(t:Float):Float {
        return 1 + (--t) * t * t;
    }

/** Cubic in and out. */

    public static function cubeInOut(t:Float):Float {
        return t <= .5 ? t * t * t * 4 : 1 + (--t) * t * t * 4;
    }

/** Quart in. */

    public static function quartIn(t:Float):Float {
        return t * t * t * t;
    }

/** Quart out. */

    public static function quartOut(t:Float):Float {
        return 1 - (t -= 1) * t * t * t;
    }

/** Quart in and out. */

    public static function quartInOut(t:Float):Float {
        return t <= .5 ? t * t * t * t * 8 : (1 - (t = t * 2 - 2) * t * t * t) / 2 + .5;
    }

/** Quint in. */

    public static function quintIn(t:Float):Float {
        return t * t * t * t * t;
    }

/** Quint out. */

    public static function quintOut(t:Float):Float {
        return (t = t - 1) * t * t * t * t + 1;
    }

/** Quint in and out. */

    public static function quintInOut(t:Float):Float {
        return ((t *= 2) < 1) ? (t * t * t * t * t) / 2 : ((t -= 2) * t * t * t * t + 2) / 2;
    }

/** Sine in. */

    public static function sineIn(t:Float):Float {
        return -Math.cos(PI2 * t) + 1;
    }

/** Sine out. */

    public static function sineOut(t:Float):Float {
        return Math.sin(PI2 * t);
    }

/** Sine in and out. */

    public static function sineInOut(t:Float):Float {
        return -Math.cos(PI * t) / 2 + .5;
    }

/** Bounce in. */

    public static function bounceIn(t:Float):Float {
        t = 1 - t;
        if(t < B1) return 1 - 7.5625 * t * t;
        if(t < B2) return 1 - (7.5625 * (t - B3) * (t - B3) + .75);
        if(t < B4) return 1 - (7.5625 * (t - B5) * (t - B5) + .9375);
        return 1 - (7.5625 * (t - B6) * (t - B6) + .984375);
    }

/** Bounce out. */

    public static function bounceOut(t:Float):Float {
        if(t < B1) return 7.5625 * t * t;
        if(t < B2) return 7.5625 * (t - B3) * (t - B3) + .75;
        if(t < B4) return 7.5625 * (t - B5) * (t - B5) + .9375;
        return 7.5625 * (t - B6) * (t - B6) + .984375;
    }

/** Bounce in and out. */

    public static function bounceInOut(t:Float):Float {
        if(t < .5) {
            t = 1 - t * 2;
            if(t < B1) return (1 - 7.5625 * t * t) / 2;
            if(t < B2) return (1 - (7.5625 * (t - B3) * (t - B3) + .75)) / 2;
            if(t < B4) return (1 - (7.5625 * (t - B5) * (t - B5) + .9375)) / 2;
            return (1 - (7.5625 * (t - B6) * (t - B6) + .984375)) / 2;
        }
        t = t * 2 - 1;
        if(t < B1) return (7.5625 * t * t) / 2 + .5;
        if(t < B2) return (7.5625 * (t - B3) * (t - B3) + .75) / 2 + .5;
        if(t < B4) return (7.5625 * (t - B5) * (t - B5) + .9375) / 2 + .5;
        return (7.5625 * (t - B6) * (t - B6) + .984375) / 2 + .5;
    }

/** Circle in. */

    public static function circIn(t:Float):Float {
        return -(Math.sqrt(1 - t * t) - 1);
    }

/** Circle out. */

    public static function circOut(t:Float):Float {
        return Math.sqrt(1 - (t - 1) * (t - 1));
    }

/** Circle in and out. */

    public static function circInOut(t:Float):Float {
        return t <= .5 ? (Math.sqrt(1 - t * t * 4) - 1) / -2 : (Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2;
    }

/** Exponential in. */

    public static function expoIn(t:Float):Float {
        return Math.pow(2, 10 * (t - 1));
    }

/** Exponential out. */

    public static function expoOut(t:Float):Float {
        return -Math.pow(2, -10 * t) + 1;
    }

/** Exponential in and out. */

    public static function expoInOut(t:Float):Float {
        return t < .5 ? Math.pow(2, 10 * (t * 2 - 1)) / 2 : (-Math.pow(2, -10 * (t * 2 - 1)) + 2) / 2;
    }

/** Back in. */

    public static function backIn(t:Float):Float {
        return t * t * (2.70158 * t - 1.70158);
    }

/** Back out. */

    public static function backOut(t:Float):Float {
        return 1 - (--t) * (t) * (-2.70158 * t - 1.70158);
    }

/** Back in and out. */

    public static function backInOut(t:Float):Float {
        t *= 2;
        if(t < 1) return t * t * (2.70158 * t - 1.70158) / 2;
        t --;
        return (1 - (--t) * (t) * (-2.70158 * t - 1.70158)) / 2 + .5;
    }

// Easing constants.
    private static var PI:Float = Math.PI;
    private static var PI2:Float = Math.PI / 2;
    private static var EL:Float = 2 * PI / .45;
    private static var B1:Float = 1 / 2.75;
    private static var B2:Float = 2 / 2.75;
    private static var B3:Float = 1.5 / 2.75;
    private static var B4:Float = 2.5 / 2.75;
    private static var B5:Float = 2.25 / 2.75;
    private static var B6:Float = 2.625 / 2.75;


}