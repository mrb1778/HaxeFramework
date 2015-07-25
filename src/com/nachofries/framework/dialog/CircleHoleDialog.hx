package com.nachofries.framework.dialog;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.tween.Tween;
import com.nachofries.framework.util.Drawing;

class CircleHoleDialog extends DialogContentsWrapper {
    private var tween:Tween;
    private var background:String;
    private var holeX:Float;
    private var holeY:Float;

    public function new(?holeX:Float, ?holeY:Float, background:String="0x000000", ?tween:Tween, ?easing:Easing, duration:Int=70, reverse:Bool=true):Void {
        super();

        if(holeX == null) {
            holeX = Application.SCREEN_WIDTH * .5;
        }
        if(holeY == null) {
            holeY = Application.SCREEN_HEIGHT * .5;
        }

        this.holeX = holeX;
        this.holeY = holeY;
        this.background = background;

        if(tween == null) {
            if(easing == null) {
                easing = Easing.EASE_IN_OUT;
            }
            tween = Tween.create(easing, duration);
            if(reverse) {
                tween.reverse();
            }
        }
        this.tween = tween;
    }

    override public function reset():Void {
        super.reset();
        tween.reset();
        graphics.clear();
    }

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        if(params != null) {
            if(params.x != null) {
                holeX = params.x;
            }
            if(params.y != null) {
                holeY = params.y;
            }
        }
    }


    override public function update():Void {
        super.update();
        tween.tick();

        if(!tween.isFinished()) {
            graphics.clear();
            Drawing.fillExceptHole(graphics, background, holeX, holeY, tween.getValue() * Application.SCREEN_SIZE_MIN*.5);
        } else {
            onClose();
        }
    }
}