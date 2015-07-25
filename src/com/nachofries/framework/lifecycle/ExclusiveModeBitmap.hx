package com.nachofries.framework.lifecycle;


/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.SavedSettings;
class ExclusiveModeBitmap extends LifecycleBitmap {
    var modes:Map<String, String>;
    var currentMode:String;
    var primaryMode:String;
    var secondaryMode:String;

    public function new() {
        super();
        modes = new Map<String, String>();
        setScale(1);
    }

    public function addMode(key:String, image:String):ExclusiveModeBitmap {
        modes.set(key, image);
        if(primaryMode == null) {
            primaryMode = key;
            currentMode = primaryMode;
            setMode();
        } else {
            if(secondaryMode == null) {
                secondaryMode = key;
            }
        }
        return this;
    }

    public function setOn(on:Bool=true):Void {
        setMode(on ? primaryMode : secondaryMode);
    }
    public function toggle():Void {
        setMode(isPrimaryMode() ? secondaryMode : primaryMode );
    }

    override public function setMode(?newMode:String, persist:Bool = true):Void {
        if(newMode == null) {
            newMode = primaryMode;
        }
        for(mode in modes.keys()) {
            var image:String = modes.get(mode);
            if(newMode == mode) {
                loadBitmapData(image);
                currentMode = newMode;
            }
        }
    }
    override public function getMode():String { return currentMode; }
    override public function hasMode(mode:String):Bool { return modes.exists(mode); }
    override public function isPrimaryMode():Bool { return primaryMode == currentMode;  }


    public function setModeObserver(newMode:Dynamic):Void {
        setMode(Std.string(newMode));
    }
    public function observeSetting(setting:String):ExclusiveModeBitmap {
        setModeObserver(SavedSettings.getSetting(setting));
        SavedSettings.observe(setting, setModeObserver);
        return this;
    }

}