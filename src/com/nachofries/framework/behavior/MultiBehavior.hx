package com.nachofries.framework.behavior;
import com.nachofries.framework.util.Displayable;

/**
 * ...
 * @author Michael R. Bernstein
 */

class MultiBehavior extends Behavior {
    private var behaviors:Array<Behavior>;

    public function new(?behaviors:Array<Behavior>) {
        super();
        if(behaviors != null) {
            this.behaviors = behaviors;
        } else {
            this.behaviors = new Array<Behavior>();
        }
	}
    public function addBehavior(behavior:Behavior):Behavior {
        behaviors.push(behavior);
        if(target != null) {
            behavior.setTarget(target);
        }
        return this;
    }
    public function setBehaviors(behaviors:Array<Behavior>):Void {
        for(behavior in this.behaviors) {
            behavior.destroy();
        }
        this.behaviors = behaviors;
    }
    public function addAll(behaviors:Array<Behavior>):Void {
        for (behavior in behaviors) {
            addBehavior(behavior);
        }
    }
    override public function setTarget(target:Displayable):Void {
        super.setTarget(target);
        for (behavior in behaviors) {
            behavior.setTarget(target);
        }
    }
    override public function update():Void  {
		super.update();
        var allComplete:Bool = true;
        for (behavior in behaviors) {
            behavior.update();
            allComplete = allComplete && behavior.complete;
        }
        if(allComplete) {
            onComplete();
        }
	}

    override public function reset():Void {
        super.reset();
        for (behavior in behaviors) {
            behavior.reset();
        }
    }

    public static function create(behaviors:Array<Behavior>):MultiBehavior {
        var multiBehavior = new MultiBehavior();
        multiBehavior.addAll(behaviors);
        return multiBehavior;
    }

    override public function destroy():Void {
        super.destroy();
        for (behavior in behaviors) {
            behavior.destroy();
        }
        behaviors.splice(0, behaviors.length);
    }
}