package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

class Size  {
    private var width:Float;
    private var height:Float;

    public function new(width:Float, height:Float) {
        setWidth(width);
        setHeight(height);
    }

	public function setWidth(width:Float):Void { this.width = width; }
    public function setHeight(height:Float):Void { this.height = height; }    
	public function getWidth(): Float { return width; }
	public function getHeight(): Float { return height; }
}