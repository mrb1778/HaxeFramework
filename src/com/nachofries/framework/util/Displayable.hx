package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

import com.nachofries.framework.behavior.Behavior;
interface Displayable extends Positionable {
    public function getName():String;

    public function getAlpha():Float;
    public function setAlpha(opacity:Float):Void;

    public function getVisible():Bool;
    public function setVisible(visible:Bool):Void;

    public function setRed(value:Float):Void;
    public function getRed():Float;
    public function setGreen(value:Float):Void;
    public function getGreen():Float;
    public function setBlue(value:Float):Void;
    public function getBlue():Float;

    public function setFlipX(?value:Bool):Void;
    public function getFlipX():Bool;

    public function setFlipY(?value:Bool):Void;
    public function getFlipY():Bool;
    
    public function setBehavior(behavior:Behavior):Void;
    public function getBehavior():Behavior;

    public function isPrimaryMode():Bool;
    public function hasMode(mode:String):Bool;
    public function setMode(?mode:String, persist:Bool = true):Void;
    public function getMode():String;
    public function update():Void;

    public function destroy():Void;
}