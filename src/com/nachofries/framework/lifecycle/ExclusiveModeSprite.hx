package com.nachofries.framework.lifecycle;
import com.nachofries.framework.lifecycle.LifecycleSprite;


/**
 * ...
 * @author Michael R. Bernstein
 */

class ExclusiveModeSprite extends LifecycleSpriteWatcher {
	var modes:Map<String, LifecycleSprite>;
	var currentMode:String;
	var primaryMode:String;
	var secondaryMode:String;

	public function new() {
		super();
        modes = new Map<String, LifecycleSprite>();
	}

    public function addMode(key:String, sprite:LifecycleSprite):Void {
        modes.set(key, sprite);
        if(primaryMode == null) {
            primaryMode = key;
            currentMode = primaryMode;
            setMode();
        } else {
            if(secondaryMode == null) {
                secondaryMode = key;
            }
        }
    }

	public function setOn(on:Bool=true):Void {
        setMode(on ? primaryMode : secondaryMode);
    }
    public function toggle():Void {
        setMode(isPrimaryMode() ? secondaryMode : primaryMode );
    }

    override public function hasMode(mode:String):Bool {return modes.exists(mode); }
    override public function setMode(?newMode:String, persist:Bool = true):Void {
        if(newMode == null) {
            newMode = primaryMode;
        }
        for(mode in modes.keys()) {
            var sprite:LifecycleSprite = modes.get(mode);
            if(newMode == mode) {
                sprite.setVisible(true);
                currentMode = newMode;
                addAndWatchSprite(sprite);
            } else {
                sprite.setVisible(false);
                removeSprite(sprite);
            }
        }
    }
    override public function getMode():String { return currentMode; }
	override public function hasMode(mode:String):Bool { return modes.exists(mode); }
	override public function isPrimaryMode():Bool { return primaryMode == currentMode;  }
}