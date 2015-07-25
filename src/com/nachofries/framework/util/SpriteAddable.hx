package com.nachofries.framework.util;

import openfl.geom.Point;
import com.nachofries.framework.util.Displayable;
/**
 * ...
 * @author Michael R. Bernstein
 */


interface SpriteAddable {
    public function addSprite(sprite:Displayable, foreground:Bool=true):Void;
    public function getCreateLocation():Point;
}