package com.nachofries.framework.behavior;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.util.DisplayableFields;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.DisplayableField;
import com.nachofries.framework.tween.Tween;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TweenFieldBehavior extends Behavior {
    public var tween:Tween;
    private var field:DisplayableField;
    private var beginValue:Float;
    private var endValue:Float;

    private var deltaSet:Bool;
    private var beginSet:Bool;
    private var endSet:Bool;

    private var delta:Float;

    public static inline function create(tween:Tween, field:DisplayableField):TweenFieldBehavior {
        var item:TweenFieldBehavior = Pooling.get(ClassInfo.getClassName());
        if(item == null) {
            item = new TweenFieldBehavior();
        }
        item.init(tween, field);
        return item;
    }

    private function new() {
        super();
    }

    public function init(tween:Tween, field:DisplayableField):Void {
        this.tween = tween;
		this.field = field;
        beginValue = 0;
        endValue = 0;
        delta = 0;
        deltaSet = false;
        beginSet = false;
        endSet = false;
	}
    public function setEndValue(endValue:Float):TweenFieldBehavior {
        this.endValue = endValue;
        endSet = true;
        return this;
    }
    public function setRange(beginValue:Float, endValue:Float):TweenFieldBehavior {
        this.beginValue = beginValue;
        this.delta = endValue - beginValue;
        beginSet = true;
        endSet = true;
        deltaSet = true;
        return this;
    }
    public function setDelta(delta:Float):TweenFieldBehavior {
        this.delta = delta;
        deltaSet = true;
        return this;
    }

    override public function setTarget(target:Displayable):Void {
        super.setTarget(target);
        if(!beginSet) {
            beginValue = DisplayableFields.getValue(target, field);
        }
        if(endSet && !deltaSet) {
            delta = endValue - beginValue;
        }
    }

    override public function update():Void  {
		super.update();
        if(!tween.isFinished()) {
            var value:Float = beginValue + tween.tick() * delta;
            DisplayableFields.setValue(target, field, value);
        } else if(!complete) {
            onComplete();
        }
	}

    override public function reset():Void {
        super.reset();
        tween.reset();
    }

    override public function destroy():Void {
        super.destroy();
        tween.destroy();
        Pooling.recycle(this);
    }
}