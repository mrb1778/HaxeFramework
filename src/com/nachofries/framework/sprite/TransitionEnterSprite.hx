package com.nachofries.framework.sprite;
import com.nachofries.framework.util.DialogHandler;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.tween.Tween;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.lifecycle.LifecycleSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TransitionEnterSprite extends LifecycleSprite {
    private var transitionTween:Tween;
    /*private var leftTransition:DisplayObject;
    private var rightTransition:DisplayObject;*/

    private var onCompleteHandler:DialogHandler;

    private static var instance:TransitionEnterSprite;

    public static function getInstance(onCompleteHandler:DialogHandler):TransitionEnterSprite  {
        if (instance == null) {
            instance = new TransitionEnterSprite();
        }
        instance.populate(onCompleteHandler);
        return instance;
    }

	public function new() {
        super();

        transitionTween = Tween.create(Easing.EASE_IN, 20);
        //transitionTween.reverse();

        /*leftTransition = Drawing.loadImage("screens/transition-left");
        leftTransition.x = 0;
        leftTransition.y = 0;
        addChild(leftTransition);
        rightTransition = Drawing.loadImage("screens/transition-right");
        leftTransition.x = Application.SCREEN_WIDTH*.5;
        rightTransition.y = 0;
        addChild(rightTransition);*/
    }

	override public function update():Void {
		super.update();
        if(!transitionTween.isFinished()) {
            var transitionValue:Float = transitionTween.tick();
            alpha = 1 - transitionValue;
            //x = -transitionValue * Application.SCREEN_WIDTH;

            //Drawing.fillScreenWithColor(graphics, 0x000000, transitionValue);
            //var percent:Float = transitionTween.getPercent();
            /*var offset = Application.SCREEN_WIDTH*.5 * transitionValue;
            leftTransition.x = -offset;
            rightTransition.x = Application.SCREEN_WIDTH*.5 + offset;*/
        } else {
            /*leftTransition.x = -leftTransition.width;
            rightTransition.x = Application.SCREEN_WIDTH;*/
            visible = false;
            onCompleteHandler.removeDialog();
        }
	}

    public function populate(onCompleteHandler:DialogHandler):Void {
        transitionTween.reset();
        /*leftTransition.x = 0;
        leftTransition.x = Application.SCREEN_WIDTH*.5;*/
        alpha = 1;
        //x = 0;
        visible = true;
        this.onCompleteHandler = onCompleteHandler;
    }
}