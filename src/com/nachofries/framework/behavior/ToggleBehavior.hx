package com.nachofries.framework.behavior;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.DisplayableFields;
import com.nachofries.framework.util.DisplayableField;
class ToggleBehavior extends Behavior {
	public static inline var DEFAULT_RATE:Int = 5;

	private var rate:Int = DEFAULT_RATE;
    private var randomRate:Bool;
    private var nextToggle:Int;
    private var togglesLeft:Int = -1;

    private var displayableField:DisplayableField;
    private var onValue:Float= 1;
    private var offValue:Float=0;

	public function new(numToggles:Int=-1, rate:Int=DEFAULT_RATE, randomRate:Bool=false, ?displayableField:DisplayableField, onValue:Float=1, offValue:Float=0) {
        super();
		this.rate = rate;
        this.randomRate = randomRate;
        this.togglesLeft = numToggles*2;
        nextToggle = rate;

        if(displayableField == null) {
            this.displayableField = DisplayableField.ALPHA;
        }
        this.onValue = onValue;
        this.offValue = offValue;
    }
	override public function update():Void  {
        super.update();
        if(!complete) {
            if (nextToggle-- == 0) {
                if(randomRate) {
                    nextToggle = Math.round(Math.random() * rate);
                } else {
                    nextToggle = rate;
                }
                DisplayableFields.setValue(target, displayableField, target.getAlpha() == onValue ? offValue : onValue);

                if(togglesLeft > 0) {
                    if(--togglesLeft == 0) {
                        onComplete();
                    }
                }
            }
        }
	}

    override public function onComplete():Void {
        super.onComplete();
        target.setAlpha(1);
    }
}