package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

interface Positionable {
    public function getLeftX():Float;
    public function setLeftX(x:Float):Void;

    public function getCenterX():Float;
    public function setCenterX(x:Float):Void;

    public function getRightX():Float;
    public function setRightX(x:Float):Void;

    public function getTopY():Float;
    public function setTopY(y:Float):Void;

    public function getCenterY():Float;
    public function setCenterY(y:Float):Void;

    public function getBottomY():Float;
    public function setBottomY(y:Float):Void;

    public function getWidth():Float;
    public function getHeight():Float;

    public function getScale():Float;
    public function setScale(value:Float):Void;

    public function getScaleX():Float;
    public function setScaleX(value:Float):Void;

    public function getScaleY():Float;
    public function setScaleY(value:Float):Void;

    public function getRotation():Float;
    public function setRotation(rotation:Float):Void;

}