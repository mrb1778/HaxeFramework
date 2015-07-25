package com.nachofries.framework.util;


import openfl.display.DisplayObject;

/**
 * ...
 * @author Michael R. Bernstein
 */

class DisplayObjectWrapper implements Displayable {
    private var object:DisplayObject;

    public function new(object:DisplayObject) {
        this.object = object;
    }

    public function getLeftX():Float { return object.x; }
    public function setLeftX(x:Float):Void { object.x = x; }

    public function getCenterX():Float { return object.x + object.width * .5; }
    public function setCenterX(x:Float):Void { object.x = x - object.width * .5; }

    public function getRightX():Float { return object.x + object.width; }
    public function setRightX(x:Float):Void { object.x = x - object.width; }

    public function getTopY():Float { return object.y; }
    public function setTopY(y:Float):Void { object.y = y; }

    public function getCenterY():Float { return object.y + object.height * .5; }
    public function setCenterY(y:Float):Void { object.y = y - object.height * .5; }

    public function getBottomY():Float { return object.y + object.height; }
    public function setBottomY(y:Float):Void { object.y = y - object.height; }

    public function setWidth(width:Float):Void { object.width = width; }
    public function setHeight(height:Float):Void { object.height = height; }
    public function getWidth(): Float { return object.width; }
    public function getHeight(): Float { return object.height; }
}