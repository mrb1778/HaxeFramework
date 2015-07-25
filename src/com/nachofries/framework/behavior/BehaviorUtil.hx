package com.nachofries.framework.behavior;
import com.nachofries.framework.util.DisplayableFields;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.DisplayableField;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.tween.Tween;
class BehaviorUtil {
    public static inline function dip(duration:Int=10, dipAmount:Float=20):TweenFieldBehavior {
        //todo: test
        return TweenFieldBehavior.create(Tween.create(Easing.SINOIDAL, duration), DisplayableField.Y_TOP).setDelta(Application.SCALE * dipAmount);
    }

    public static inline function dropIn(endValue:Float, duration:Int=40):TweenFieldBehavior {
        var behavior:TweenFieldBehavior = TweenFieldBehavior.create(Tween.create(Easing.SINOIDAL, duration), DisplayableField.Y_TOP);
        behavior.setEndValue(endValue);
        return behavior;
    }

    public static inline function shake(duration:Int=20, shakeAmount:Float=20):TweenFieldBehavior {
        return TweenFieldBehavior.create(Tween.create(Easing.WOBBLE, duration), DisplayableField.Y_CENTER);
    }

    public static inline function fadeIn(duration:Int=100, ?fieldType:DisplayableField):TweenFieldBehavior {
        if(fieldType == null) {
            fieldType = DisplayableField.ALPHA;
        }
        return TweenFieldBehavior.create(Tween.create(Easing.SINOIDAL, duration), fieldType).setEndValue(1);
    }
    public static inline function fadeOut(duration:Int=100, ?fieldType:DisplayableField, removeTargetAfterTween:Bool=false):TweenFieldBehavior {
        if(fieldType == null) {
            fieldType = DisplayableField.ALPHA;
        }
        var behavior:TweenFieldBehavior = TweenFieldBehavior.create(Tween.create(Easing.SINOIDAL, duration), fieldType).setEndValue(0);
        if(removeTargetAfterTween) {
            behavior.setRemoveTargetAfterTween(true);
        }
        return behavior;
    }

    /*public static inline function increaseSize(increaseAmount:Float=1):TweenBehavior {
        return TweenBehavior.create(Tween.create(Easing.SINOIDAL, cast(100 * increaseAmount, Int)), DisplayableField.SCALE, 1);
    }*/

    public static inline function tweenTo(time:Int=3, ?displayableField:DisplayableField, endValue:Float = 0, ?easing:Easing):TweenFieldBehavior {
        if(displayableField == null) {
            displayableField = DisplayableField.SCALE;
        }
        if(easing == null) {
            easing = Easing.EASE_OUT;
        }
        var behavior:TweenFieldBehavior = TweenFieldBehavior.create(Tween.create(easing, time), displayableField);
        behavior.setEndValue(endValue);
        return behavior;
    }

    public static inline function minMax(?field:DisplayableField, minValue:Float=.5, maxValue:Float=1, increment:Float=.1, delta:Float=0, ?easing:Easing):TweenFieldBehavior {
        if(field == null) {
            field = DisplayableField.ALPHA;
        }
        if(easing == null) {
            easing = Easing.EASE_IN_OUT;
        }
        var tween:Tween = Tween.create(easing, Std.int(Math.abs(minValue == maxValue ? delta : maxValue - minValue) / increment));
        tween.setRepeat();
        var behavior:TweenFieldBehavior = TweenFieldBehavior.create(tween, field);
        if(minValue != maxValue) {
            behavior.setRange(minValue, maxValue);
        } else {
            behavior.setDelta(delta);
        }
        return behavior;
    }

    public static inline function moveTo(x:Float, y:Float, ?xPosistionType:DisplayableField, time:Int=80, ?easing:Easing):MultiBehavior {
        if(xPosistionType == null) {
            xPosistionType = DisplayableField.X_CENTER;
        }
        var yPosistionType:DisplayableField = DisplayableFields.getYEquivalent(xPosistionType);

        if(easing == null) {
            easing = Easing.EASE_IN_OUT;
        }
        var behavior:MultiBehavior = new MultiBehavior([
             TweenFieldBehavior.create(Tween.create(easing, time), xPosistionType).setEndValue(x),
             TweenFieldBehavior.create(Tween.create(easing, time), yPosistionType).setEndValue(y)
        ]);

        /*behavior.setOnCompleteCallback(function(behavior:Behavior):Void {
            DisplayableFields.setValue(behavior.getTarget(), xPosistionType, x);
            DisplayableFields.setValue(behavior.getTarget(), yPosistionType, y);
        });*/
        return behavior;
    }

    public static inline function moveToAndDisappear(x:Float, y:Float, time:Int=80, removeTargetAfterTween:Bool=true, ?callback:Behavior->Void):MultiBehavior {
        return MultiBehavior.create([
               BehaviorUtil.fadeOut(time, DisplayableField.ALPHA, removeTargetAfterTween).setOnCompleteCallback(callback),
               BehaviorUtil.fadeOut(time, DisplayableField.SCALE),
               BehaviorUtil.moveTo(x, y, time)
        ]);
    }

    public static function createFromJson(json:Dynamic):Behavior {
        if(json == null) {
            return null;
        } else if(json.type == "Multi") {
            var multiMovement:MultiBehavior = new MultiBehavior();
            var behaviors:Array<Dynamic> = json.behaviors;
            for(singleBehavior in behaviors) {
                multiMovement.addBehavior(createFromJson(singleBehavior));
            }
            return multiMovement;
        } else if(json.type == "Sequential") {
            var multiMovement:SequentialBehavior = new SequentialBehavior();
            var behaviors:Array<Dynamic> = json.behaviors;
            for(singleBehavior in behaviors) {
                multiMovement.addBehavior(createFromJson(singleBehavior));
            }
            return multiMovement;
        } else if(json.type == "Dip") {
            var behavior = dip();
            behavior.tween.currentRepeat = -1;
            return behavior;
        } else if(json.type == "DropIn") {
            var behavior = dropIn(json.endValue * Application.SCALE, json.duration);
            return behavior;
        } else if(json == "FadeOut" || json.type == "FadeOut") {
            var behavior = fadeOut(json.decay);
            return behavior;
        } else if(json.type == "Toggle") {
            var behavior = new ToggleBehavior(json.numBlinks, json.rate, json.random==true);
            return behavior;
        } else if(json.type == "MinMax") {
            //todo: scale?
            return minMax(Type.createEnum(DisplayableField, json.field), json.minValue, json.maxValue, json.increment, json.delta, json.easing != null ? Type.createEnum(Easing, json.easing, json.easingParams) : null);
        } else if(json.type == "Change") {
            return ChangeBehavior.createFromJson(json);
        } else if(json.type == "RepeatFall") {
            return RepeatFallBehavior.create(json.verticalSpeed, json.horizontalSpeed, json.width, json.height);
        }
        return null;
    }

}
