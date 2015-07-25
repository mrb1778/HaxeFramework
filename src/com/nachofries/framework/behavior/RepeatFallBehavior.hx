package com.nachofries.framework.behavior;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Application;

/**
 * ...
 * @author Michael R. Bernstein
 */

class RepeatFallBehavior extends Behavior {
    public static inline var VERTICAL_SPEED_DEFAULT:Float = 5;

    private var width:Float;
    private var height:Float;


    private var minX:Float;
    private var maxX:Float;
    private var minY:Float;
    private var maxY:Float;

    private var originalScale:Float;
    private var defaultVerticalSpeed:Float;
    private var defaultHorizontalSpeed:Float;

    private var verticalSpeed:Float;
    private var horizontalSpeed:Float;

    public static inline function create(?verticalSpeed:Float, horizontalSpeed:Float=0, width:Float=0, height:Float=0):RepeatFallBehavior {
        var item:RepeatFallBehavior = Pooling.get(ClassInfo.getClassName());
        if(item == null) {
            item = new RepeatFallBehavior();
        }
        
        if(verticalSpeed == null) {
            verticalSpeed = VERTICAL_SPEED_DEFAULT * Application.SCALE;
        }
        item.defaultVerticalSpeed = verticalSpeed;
        item.defaultHorizontalSpeed = horizontalSpeed;

        if(width == 0) {
            width = Application.SCREEN_WIDTH; 
        }
        item.width = width;
        
        if(height == 0) {
            height = Application.SCREEN_HEIGHT; 
        }
        item.height = height;
        return item;
    }

    private function new() {
        super();
    }

    override public function setTarget(target:Displayable):Void {
        super.setTarget(target);

        minX = target.getLeftX();
        minY = target.getTopY();
        maxX = minX + width;
        maxY = minY + height;

        //target.setTopY(minY + (maxY - minY) * Math.random());
        originalScale = target.getScale();
        randomize();
    }

    function randomize():Void {
        var scaleFactor = Math.random() + .5;

        verticalSpeed = scaleFactor * defaultVerticalSpeed;
        horizontalSpeed = scaleFactor * defaultHorizontalSpeed;

        target.setScale(originalScale * scaleFactor);
        target.setLeftX(minX + (maxX - minX) * Math.random());
        target.setAlpha(Math.random() * .4 + .6);
    }
    override public function update():Void {
        super.update();

        Placement.moveVertical(target, verticalSpeed);
        Placement.moveHorizontal(target, horizontalSpeed);
        if(target.getBottomY() > maxY) {
            target.setTopY(minY);
            randomize();
        }
    }

    override public function destroy():Void {
        super.destroy();
        Pooling.recycle(this);
    }
}