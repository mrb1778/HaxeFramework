package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

//class Rectangle extends flash.geom.Rectangle implements Displayable {
import openfl.geom.Point;
class Rectangle extends openfl.geom.Rectangle implements Positionable {
    private static var instance:Rectangle = new Rectangle();
    private static var instance2:Rectangle = new Rectangle();

    public static function getTempInstance(x:Float, y:Float, width:Float, height:Float):Rectangle {
        instance.x = x;
        instance.y = y;
        instance.width = width;
        instance.height = height;

        return instance;
    }

    public static function getTempInstance2(x:Float, y:Float, width:Float, height:Float):Rectangle {
        instance2.x = x;
        instance2.y = y;
        instance2.width = width;
        instance2.height = height;

        return instance2;
    }

    private var scaleX:Float;
    private var scaleY:Float;

    public function getLeftX():Float { return x; }
    public function setLeftX(x:Float):Void { this.x = x; }

    public function getCenterX():Float { return x + width * .5; }
    public function setCenterX(x:Float):Void { this.x = x - width * .5; }

    public function getRightX():Float { return x + width; }
    public function setRightX(x:Float):Void { this.x = x - width; }

    public function getTopY():Float { return y; }
    public function setTopY(y:Float):Void { this.y = y; }

    public function getCenterY():Float { return y + height * .5; }
    public function setCenterY(y:Float):Void { this.y = y - height * .5; }

    public function getBottomY():Float { return y + height; }
    public function setBottomY(y:Float):Void { this.y = y - height; }

	public function setWidth(width:Float):Void { this.width = width; }
    public function setHeight(height:Float):Void { this.height = height; }    
	public function getWidth(): Float { return width; }
	public function getHeight(): Float { return height; }

    public function setSize(width:Float, height:Float):Void {
        setWidth(width);
        setHeight(height);
    }

    public function getLocation():Point { return new Point(x, y); }
    public function getScale():Float { return scaleX; }
    public function setScale(scale:Float):Void {
        setScaleX(scale);
        setScaleY(scale);
    }

    public function getScaleX():Float { return scaleX; }
    public function setScaleX(scale:Float):Void {
        this.scaleX = scale;
        this.x *= scaleX;
        this.width *= scaleX;
    }

    public function getScaleY():Float { return scaleY; }
    public function setScaleY(scale:Float):Void {
        this.scaleY = scale;
        this.y *= scale;
        this.height *= scale;
    }

    public function getRotation():Float { return 0.0; }
    public function setRotation(rotation:Float):Void {  }

    public function move(x:Float, y:Float):Void {
        this.x += x;
        this.y += y;
    }

    public function containsAABB(x:Float, y:Float, width:Float, height:Float):Bool {
        return containsRect(Rectangle.getTempInstance(
            x,
            y,
            width,
            height)
        );
    }

    public function containsPositionable(object:Positionable):Bool {
        return containsAABB(object.getLeftX(),
                            object.getTopY(),
                            object.getWidth(),
                            object.getHeight());
    }
}