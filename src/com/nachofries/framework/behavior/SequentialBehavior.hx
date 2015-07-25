package com.nachofries.framework.behavior;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.Displayable;
class SequentialBehavior extends MultiBehavior {
    private var repeat:Bool;
    private var index:Int;

    public function new(repeat:Bool=false) {
        super();
        this.repeat = repeat;
        index = 0;
	}

    override public function update():Void  {
        if(index >= behaviors.length) {
            if(repeat) {
                index = 0;
            } else if(!complete) {
                onComplete();
            }
        } else {
            var behavior = behaviors[index];
            behavior.update();

            if(behavior.complete) {
                index++;
                if(index < behaviors.length) {
                    behaviors[index].setTarget(target);
                }
            }
        }
	}

    override public function setTarget(target:Displayable):Void {
        this.target = target;
        behaviors[0].setTarget(target);
    }

    public static function create(behaviors:Array<Behavior>):MultiBehavior {
        var sequentialBehavior = new SequentialBehavior();
        sequentialBehavior.addAll(behaviors);
        return sequentialBehavior;
    }

    override public function destroy():Void {
        super.destroy();
        for (behavior in behaviors) {
            behavior.destroy();
        }
        behaviors.splice(0, behaviors.length);
    }
}