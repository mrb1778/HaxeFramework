package com.nachofries.framework.dialog;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.tween.Tween;
import com.nachofries.framework.util.Drawing;

/**
 * ...
 * @author Michael R. Bernstein
 */

class CircleHoleDialogBox extends DialogBox {
    private var background:String;
    private var tween:Tween;

    private var holeX:Float;
    private var holeY:Float;
    private var holeSize:Float;

	public function new(?dialogContents:DialogContents, ?options:Map<String, Dynamic>, background:String="0x000000", ?tween:Tween, ?easing:Easing, duration:Int=80, reverse:Bool=false) {
		super(dialogContents, options);
        this.background = background;

        if(tween == null) {
            if(easing == null) {
                easing = Easing.EASE_IN_OUT;
            }
            tween = Tween.create(easing, duration);
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
            holeX = params.x;            
            holeY = params.y;            
            holeSize = params.size * 3;
        }
    }

    override public function update():Void {
        super.update();
        tween.tick();

        if(!tween.isFinished()) {
            graphics.clear();
            Drawing.fillExceptHole(graphics, background, holeX, holeY, holeSize * (1-tween.getValue()));
        } 
    }
}