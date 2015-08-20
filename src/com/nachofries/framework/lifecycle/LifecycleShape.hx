package com.nachofries.framework.lifecycle;
import openfl.display.Shape;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.NumberUtils;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.behavior.Behavior;

/**
 * ...
 * @author Michael R. Bernstein
 */

@final
class LifecycleShape extends Shape implements Displayable {
    private var behavior:Behavior;
    private var shouldReset:Bool;

    private var red:Float;
    private var green:Float;
    private var blue:Float;

    private var flipX:Bool = false;
    private var flipY:Bool = false;

    private var rotationSet:Float = 0;

    public static inline function create():LifecycleShape {
        var shape:LifecycleShape = Pooling.get(ClassInfo.getClassName());

        if(shape == null) {
            shape = new LifecycleShape();
        }
        return shape;
    }

    private function new() {
        super();
    }

    public function start():Void {}
    public function stop():Void {}
    public function update():Void {
        if(behavior != null) {
            behavior.update();
        }
    }

    inline public function getLeftX():Float { return x; }
    inline public function setLeftX(x:Float):Void { this.x = x; locationChanged(); }

    public function getCenterX():Float { return x + getWidth() * .5; }
    public function setCenterX(x:Float):Void { this.x = x - getWidth() * .5; locationChanged(); }

    public function getRightX():Float { return x + getWidth(); }
    public function setRightX(x:Float):Void { this.x = x - getWidth(); locationChanged(); }

    public function getTopY():Float { return y; }
    public function setTopY(y:Float):Void { this.y = y; locationChanged(); }

    public function getCenterY():Float { return y + getHeight() * .5; }
    public function setCenterY(y:Float):Void {
        this.y = y - getHeight() * .5;
        locationChanged();
    }

    public function getBottomY():Float { return y + getHeight(); }
    public function setBottomY(y:Float):Void { this.y = y - getHeight(); locationChanged(); }

    private function locationChanged():Void {

    }

    public function getWidth():Float { return width; }
    public function getHeight():Float { return height; }


    public function hasMode(mode:String):Bool {return false; }
    public function setMode(?mode:String, persist:Bool = true):Void { }
    public function getMode():String { return null; }
    public function isPrimaryMode():Bool { return true;  }

    public function reset():Void {
        if(behavior != null) {
            behavior.reset();
        }
    }
    public function resetDisplay():Void {
        graphics.clear();
    }
    public inline function resetLocation():Void {
        x = 0;
        y = 0;
    }
    public inline function setBehavior(behavior:Behavior):Void {
        if(this.behavior != null) {
            this.behavior.destroy();
        }
        if(behavior != null) {
            behavior.setTarget(this);
        }
        this.behavior = behavior;
    }
    public function getBehavior():Behavior { return behavior; }

    public function destroy():Void {
        shouldReset = false;
        red = 0;
        green = 0;
        blue = 0;
        flipY = false;
        flipX = false;
        rotationSet = 0;

        setBehavior(null);
        if(parent != null) {
            parent.removeChild(this);
        }

        resetDisplay();
        resetLocation();

        Pooling.recycle(this);
    }

    public inline function getVisible():Bool {return visible; }
    public inline function setVisible(value:Bool):Void { this.visible = value; }

    public inline function getScale():Float { return scaleX; }
    public inline function setScale(value:Float):Void {
        setScaleX(value);
        setScaleY(value);
    }

    public inline function getScaleX():Float { return scaleX; }
    public inline function setScaleX(value:Float):Void {
        var center:Float = getCenterX();
        this.scaleX = value;
        setCenterX(center);
    }

    public inline function getScaleY():Float { return scaleY; }
    public inline function setScaleY(value:Float):Void {
        var center:Float = getCenterY();
        this.scaleY = value;
        setCenterY(center);
    }

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
        var originalFlip:Bool = flipY;
        if(value == null) {
            flipY = !flipY;
        } else {
            flipY = value;
        }
        if(originalFlip != flipY) {
            setScaleY(getScaleY()*-1);
        }
    }
    public function getFlipY():Bool { return flipY; }

    public inline function getRotation():Float { return NumberUtils.degreesToRadians(rotationSet); }

    public inline function setRotation(rotation:Float):Void {
        rotation = NumberUtils.radiansToDegrees(rotation);
        rotation %= 360;
        Drawing.rotateCenter(this, rotation - rotationSet);
        rotationSet = rotation;
    }


    public inline function getAlpha():Float {return alpha; }
    public inline function setAlpha(value:Float):Void { this.alpha = value; }

    public function setName(name:String):Void { this.name = name; }
    public function getName():String { return name; }
}