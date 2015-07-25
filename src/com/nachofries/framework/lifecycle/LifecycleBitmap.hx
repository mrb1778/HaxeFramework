package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.Drawing;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import com.nachofries.framework.util.NumberUtils;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.behavior.Behavior;

/**
 * ...
 * @author Michael R. Bernstein
 */

class LifecycleBitmap extends Bitmap implements Displayable {
    private var behavior:Behavior;
	private var shouldReset:Bool;

    private var red:Float;
    private var green:Float;
    private var blue:Float;

    private var flipX:Bool = false;
    private var flipY:Bool = false;

    private var rotationSet:Float = 0;

    public function new(?bitmapData:BitmapData) {
        super(bitmapData, null, true);

    }

	public function start():Void {}
    public function stop():Void {}
	public function update():Void {
        if(behavior != null) {
            behavior.update();
        }
    }

    public function getLeftX():Float { return x; }
    public function setLeftX(x:Float):Void { this.x = x; }

    public function getCenterX():Float { return x + width * .5; }
    public function setCenterX(x:Float):Void { this.x = x - width * .5; }

    public function getRightX():Float { return x + width; }
    public function setRightX(x:Float):Void { this.x = x - width; }

    public function getTopY():Float { return y; }
    public function setTopY(y:Float):Void { this.y = y; }

    public function getCenterY():Float { return y + height * .5; }
    public function setCenterY(y:Float):Void {
        this.y = y - height * .5;
    }

    public function getBottomY():Float { return y + height; }
    public function setBottomY(y:Float):Void { this.y = y - height; }

    public inline function getWidth():Float { return width; }
    public inline function getHeight():Float { return height; }


	public function setMode(?mode:String, persist:Bool = true):Void { }
    public function getMode():String { return null; }
	public function isPrimaryMode():Bool { return true;  }
	public function hasMode(mode:String):Bool { return false;  }

	public function reset():Void {
        if(behavior != null) {
            behavior.reset();
        }
    }
	public function resetDisplay():Void {

	}
	public inline function resetLocation():Void {
		x = 0;
		y = 0;
	}
    public inline function setBehavior(behavior:Behavior):Void {
        if(behavior != null) {
            behavior.setTarget(this);
        }
        this.behavior = behavior;
    }
    public function getBehavior():Behavior { return behavior; }

    public function destroy():Void {
        bitmapData = null;
        if(behavior != null) {
            behavior.destroy();
            behavior = null;
        }
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
        this.scaleX = value * Application.SCALE;
    }

    public inline function getScaleY():Float { return scaleY; }
    public inline function setScaleY(value:Float):Void {
        this.scaleY = value  * Application.SCALE;
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
        if(value == null) {
            flipY = !flipY;
        } else {
            flipY = value;
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

    public function loadBitmapData(name:String):Void {
        bitmapData = Drawing.getBitmapData(name);
    }
}