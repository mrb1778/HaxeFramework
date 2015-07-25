package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Settings;
import com.nachofries.framework.util.Sounds;
import com.nachofries.framework.util.Events;
import openfl.events.MouseEvent;
import com.nachofries.framework.util.Drawing;

/**
 * ...
 * @author Michael R. Bernstein
 */

class LifecycleButton extends LifecycleSpriteWatcher {
    var eventName:String;
    var eventParams:Dynamic;
    var handler:MouseEvent->Void;
    var buttonBitmap:LifecycleBitmap;
    var buttonSprite:LifecycleSprite;
    var sound:String;

	public function new(?buttonImage:String, ?buttonBitmap:LifecycleBitmap, ?buttonSprite:LifecycleSprite, ?buttonText:String) {
        super();
        mouseChildren = false;

        if(buttonImage != null) {
            addChild(Drawing.loadImage(buttonImage));
        }

        if(buttonBitmap != null) {
            this.buttonBitmap = buttonBitmap;
            addChild(buttonBitmap);
        }
        setButtonSprite(buttonSprite);
        setText(buttonText);
    }

    public function setButtonSprite(buttonSprite:LifecycleSprite):LifecycleButton {
        if(buttonSprite != null) {
            if(this.buttonSprite != null) {
                this.buttonSprite.destroy();
            }
            this.buttonSprite = buttonSprite;
            addAndWatchSprite(buttonSprite);
        }
        return this;
    }

    public function setText(text:String):LifecycleButton {
        if(text != null && text != "") {
            var textSprite:TextSprite = new TextSprite(text);
            Placement.centerIn(this, textSprite);
            setButtonSprite(textSprite);
        }
        return this;
    }


    public function setEvent(eventName:String, ?eventParams:Dynamic):LifecycleButton {
        this.eventName = eventName;
        this.eventParams = eventParams;
        return this;
    }

    public function setHandler(handler:MouseEvent->Void):LifecycleButton {
        this.handler = handler;
        return this;
    }

    public function setSound(sound:String):LifecycleButton {
        this.sound = sound;
        return this;
    }

    public override function start():Void {
        super.start();
        addEventListener(MouseEvent.CLICK, onClick);
        //addEventListener(TouchEvent.TOUCH_TAP, onClick);
    }
    public override function stop():Void {
        super.stop();
        removeEventListener(MouseEvent.CLICK, onClick);
        //addEventListener(TouchEvent.TOUCH_TAP, onClick);
    }
    function onClick(event:MouseEvent):Void {
        event.stopPropagation();
        if(handler != null) {
            handler(event);
        }
        if(eventName != null) {
            Events.fire(eventName, eventParams);
        }
        if(sound != null) {
            Sounds.playSound(sound);
        } else if(Settings.hasSetting("button.sound")) {
            Sounds.playSound(Settings.getSetting("button.sound"));
        }
    }

    override public function hasMode(mode:String):Bool {
        if(buttonBitmap != null) {
            return buttonBitmap.hasMode(mode);
        }
        if(buttonSprite != null) {
            return buttonSprite.hasMode(mode);
        }

        return super.hasMode(mode);
    }

    override public function setMode(?mode:String, persist:Bool = true):Void {
        super.setMode(mode);
        if(buttonBitmap != null) {
            buttonBitmap.setMode(mode);
        }
        if(buttonSprite != null) {
            buttonSprite.setMode(mode);
        }
    }
}