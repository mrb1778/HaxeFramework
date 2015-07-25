package com.nachofries.framework.util;
import com.nachofries.framework.util.Rectangle;
import com.nachofries.framework.behavior.Behavior;
import com.nachofries.framework.util.Displayable;

/**
 * ...
 * @author Michael R. Bernstein
 */

class PlaceholderDrawable extends Rectangle implements Displayable {
    private var name:String;
    private var behavior:Behavior;

    private var alpha:Float;
    private var visible:Bool;

    private var rotation:Float;
    private var red:Float;
    private var green:Float;
    private var blue:Float;

    private var flipX:Bool = false;
    private var flipY:Bool = false;

    public function new(width:Float, height:Float) {
        super(0, 0, width, height);

        alpha = 1;
        visible = true;
        behavior = null;

        name="placeholder";
    }

    public var memo:String;

    public function update():Void {
        if(behavior != null) {
            behavior.update();
        }
    }
    public function setMode(?mode:String, persist:Bool = true):Void { }
    public function getMode():String { return null; }
    public function isPrimaryMode():Bool { return true;  }
    public function hasMode(mode:String):Bool { return false;  }

    public inline function resetDisplay():Void {}
    public inline function resetLocation():Void {
        x = 0;
        y = 0;
    }

    public inline function getAlpha():Float { return alpha; }
    public inline function setAlpha(value:Float):Void { this.alpha = value; }

    public inline function setRed(value:Float):Void { this.red = value; }
    public inline function getRed():Float { return red; }

    public inline function setGreen(value:Float):Void { this.green = value; }
    public inline function getGreen():Float { return green; }

    public inline function setBlue(value:Float):Void { this.blue = value; }
    public inline function getBlue():Float { return blue; }

    public function setFlipX(?value:Bool):Void {
        if(value == null) {
            flipX = !flipX;
        } else {
            flipX = value;
        }
    }
    public function getFlipX():Bool { return flipX; }

    public function setFlipY(?value:Bool):Void {
        if(value == null) {
            flipY = !flipY;
        } else {
            flipY = value;
        }
    }
    public function getFlipY():Bool { return flipY; }

    public inline function getVisible():Bool { return visible; }
    public inline function setVisible(value:Bool):Void {this.visible = value; }

    public inline function remove():Void { }

    public inline function setMemo(value:String):Void { this.name = value; }
    public inline function getName():String { return name; }

    public inline function setBehavior(behavior:Behavior):Void {
        behavior.setTarget(this);
        this.behavior = behavior;
    }
    public function getBehavior():Behavior {return behavior; }

    public function destroy():Void {
        if(behavior != null) {
            behavior.destroy();
            behavior = null;
        }
    }
}