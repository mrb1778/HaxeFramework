package com.nachofries.framework.behavior;

/**
 * ...
 * @author Michael R. Bernstein
 */
import com.nachofries.framework.util.Displayable;
class Behavior {
    private var target:Displayable;
    private var complete:Bool;

    private var removeTargetAfterTween:Bool = false;
    private var removeBehaviorAfterTween:Bool = false;
    private var hideTargetAfterTween:Bool = false;
    private var onCompleteCallback:Behavior->Void;

    public function new():Void {}
    public function update():Void {}
    public function reset():Void {
        complete = false;
    }
    public function setTarget(target:Displayable):Void {
        this.target = target;
    }
    public function getTarget():Displayable {
        return target;
    }

    public function setRemoveBehaviorAfterTween(removeBehaviorAfterTween:Bool=true):Behavior {
        this.removeBehaviorAfterTween = removeBehaviorAfterTween;
        return this;
    }
    public function setRemoveTargetAfterTween(removeTargetAfterTween:Bool=true):Behavior {
        this.removeTargetAfterTween = removeTargetAfterTween;
        return this;
    }
    public function setOnCompleteCallback(?onCompleteCallback:Behavior->Void):Behavior {
        this.onCompleteCallback = onCompleteCallback;
        return this;
    }

    public function onComplete():Void {
        if(!complete) {
            complete = true;
            if(removeTargetAfterTween) {
                target.destroy();
            }
            if(hideTargetAfterTween) {
                target.setVisible(false);
            }
            if(onCompleteCallback != null) {
                onCompleteCallback(this);
                onCompleteCallback = null;
            }
            if(removeBehaviorAfterTween) {
                target.setBehavior(null);
            }
        }
    }

    public function destroy():Void {
        target = null;
        complete = false;

        removeTargetAfterTween = false;
        removeBehaviorAfterTween = false;
        hideTargetAfterTween = false;
        onCompleteCallback = null;
    }
}