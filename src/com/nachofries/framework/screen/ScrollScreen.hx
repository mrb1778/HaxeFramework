package com.nachofries.framework.screen;
import com.nachofries.framework.behavior.Behavior;
import com.nachofries.framework.util.DisplayableField;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.tween.Tween;
import com.nachofries.framework.behavior.TweenFieldBehavior;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;
import com.nachofries.framework.util.Directions;
import com.nachofries.framework.util.Direction;
import openfl.geom.Point;
import com.nachofries.framework.util.MouseHandler;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.screen.LifecycleScreen;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import openfl.Lib;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ScrollScreen extends LifecycleScreen {
    private static inline var SCROLL_TIME:Int = 8;

    private var panningLeft:Bool = true;


    private var focusIndex:Int;
    private var mouseHandler:MouseHandler;

    private var backgroundSprite:LifecycleSprite;

    private var scrollButtons:Array<LifecycleSprite>;
    private var buttonContainer:LifecycleSpriteWatcher;

    public function new(name:String) {
        super(name);

        focusIndex = 0;

        mouseHandler = new MouseHandler(this)
                            .setMouseDragListener(onMouseDrag);

        buttonContainer = new LifecycleSpriteWatcher();
        addAndWatchSprite(buttonContainer);

        scrollButtons = new Array<LifecycleSprite>();
        createScrollButtons();
    }

    override function start():Void {
        super.start();
        mouseHandler.start();
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }
    override function stop():Void {
        super.stop();
        mouseHandler.stop();
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function createScrollButtons():Void {
        if(scrollButtons.length > 0) {
            for(scrollButton in scrollButtons) {
                scrollButton.destroy();
            }
            scrollButtons.splice(0, scrollButtons.length);
            buttonContainer.graphics.clear();
        }
    }

    private function placeScrollButton(button:LifecycleSprite, index:Int):Void {
        var buttonWidth:Float = button.getWidth();
        Placement.centerVertical(button, 25*Application.SCALE);
        Placement.centerHorizontal(button, index * (buttonWidth*.5 + getSpacerDistance(buttonWidth)));
    }

    private function addScrollButton(button:LifecycleSprite):Void {
        buttonContainer.addAndWatchSprite(button);
        scrollButtons.push(button);
    }

    private function addAndPlaceScrollButton(button:LifecycleSprite, index:Int):Void {
        placeScrollButton(button, index);
        addScrollButton(button);
    }

    private function getSpacerDistance(buttonWidth:Float):Float {
        return Application.SCREEN_WIDTH *.5 - (buttonWidth*.2);
    }

    override public function updateScreen():Void {
        super.updateScreen();
        if(isPanning()) {
            if((!panningLeft && buttonContainer.getRightX() < getMaxScroll()) || (panningLeft && buttonContainer.getLeftX() > getMinScroll())) {
                stopPanning();
            }
            //afterScroll();
        }
    }

    private function getMinScroll():Float {
        return Application.SCREEN_WIDTH*.5;
    }
    private function getMaxScroll():Float {
        return Application.SCREEN_WIDTH*.5;
    }

    private function afterScroll():Void {
        var idealX = getFocusOffset();
        var distance:Float = Math.abs(buttonContainer.x - idealX);

        if(distance < Application.SCROLLING_DISTANCE) {
            focusNow();
        }
    }

    function focusNow():Void {
        stopPanning();
        buttonContainer.x = getFocusOffset();
    }

    function getFocusOffset():Float {
        if(focusIndex > 0 && focusIndex < scrollButtons.length) {
            var focusButton = scrollButtons[focusIndex];
            return Application.SCREEN_WIDTH - focusButton.getCenterX();
        } else {
            return 0;
        }
    }

    private function onMouseDrag(startPoint:Point, endPoint:Point):Void {
        var direction:Direction = Directions.getHorizontalDirectionFromPoints(startPoint, endPoint);
        Type.enumEq(direction, Direction.LEFT) ? moveRight() : moveLeft();
    }

    private function getScrollDistance():Float {
        return Application.SCREEN_WIDTH * .5;
    }
    private function isPanning():Bool {
        return buttonContainer.getBehavior() != null;
    }

    private function createMoveBehavior():TweenFieldBehavior {
        var behavior:TweenFieldBehavior = TweenFieldBehavior.create(Tween.create(Easing.SINOIDAL, SCROLL_TIME), DisplayableField.X_LEFT);
        behavior.setOnCompleteCallback(stopPanning);
        return behavior;
    }

    private function stopPanning(?_):Void {
        buttonContainer.setBehavior(null);
    }

    private function moveLeft():Void {
        if(buttonContainer.getBehavior() == null) {
            panningLeft = true;
            buttonContainer.setBehavior(createMoveBehavior().setDelta(getScrollDistance()));
        }
    }

    private function moveRight():Void {
        if(buttonContainer.getBehavior() == null) {
            panningLeft = false;
            buttonContainer.setBehavior(createMoveBehavior().setDelta(-getScrollDistance()));
        }
    }

    private function onKeyDown(event:KeyboardEvent):Void {
        switch(event.keyCode) {
            case Keyboard.RIGHT:
                moveRight();
            case Keyboard.LEFT:
                moveLeft();

        }
    }
}