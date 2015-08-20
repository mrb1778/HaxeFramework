package com.nachofries.framework.dialog;
import com.nachofries.framework.util.Position;
import com.nachofries.framework.behavior.BehaviorUtil;
import openfl.events.MouseEvent;
import com.nachofries.framework.lifecycle.LifecycleBitmap;
import com.nachofries.framework.lifecycle.LifecycleButton;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.DisplayableField;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.Settings;

/**
 * ...
 * @author Michael R. Bernstein
 */

class DialogBox extends DialogContents {
    static inline function DEFAULT_OPTIONS():Map<String, Dynamic> {
        return [
            "dialogPaddingX" => 0,
            "dialogPaddingY" => 0,
            "width" => 500,
            "height" => 200,
            "radius" => 50,
            "screenPercentY" => .5,
            "quitButtton" => true,
            "alignQuitToSprite" => false,
            "clickToRemove" => false,
            "quitEvent" => null,
            "quitEventOptions" => null,
            "drawBackground" => true,
            "background" => "0x00000055",
            "boxFill" => "0x00000055",
            "drawBox" => true,
            "backgroundImageName" => null,
            "imageName" => null,
            "sprite" => null
        ];
    }

	var dialogWidth:Float;
	var dialogHeight:Float;

	var box:LifecycleSpriteWatcher;

    private var dialogContents:DialogContents = null;
    private var sprite:LifecycleSprite = null;

    private var options:Map<String, Dynamic>;

	public function new(?dialogContents:DialogContents, ?options:Map<String, Dynamic>) {
		super();

        if(dialogContents != null) {
            var contentOptions:Map<String, Dynamic> = dialogContents.getDialogOptions();
            contentOptions = Settings.populateOptions(contentOptions, DEFAULT_OPTIONS(), "dialogBox");
            options = Settings.populateOptions(options, contentOptions, "dialogBox");
        } else {
            options = Settings.populateOptions(options, DEFAULT_OPTIONS(), "dialogBox");
        }

        this.options = options;

		x = 0;
		y = 0;
        if(options.get("drawBackground")) {
            Drawing.fillScreen(this, options.get("background"));
        }

        box = new LifecycleSpriteWatcher();

        dialogWidth = options.get("width") * Application.SCALE;
        dialogHeight = options.get("height") * Application.SCALE;
        if(options.get("drawBox")) {
            Drawing.fillBox(
                box.graphics,
                options.get("boxFill"),
                0, 0,
                dialogWidth, dialogHeight,
                options.get("radius")*Application.SCALE);
        }

        if(options.get("backgroundImageName") != null) {
            var backgroundImage:LifecycleBitmap = Drawing.loadImage(options.get("backgroundImageName"));
            dialogWidth = backgroundImage.getWidth();
            dialogHeight = backgroundImage.getHeight();
            box.addChild(backgroundImage);
        }
        if(options.get("imageName") != null) {
            sprite = Drawing.loadImageSprite(options.get("imageName"));
        }
        if(options.get("sprite") != null) {
            sprite = options.get("sprite");
        }
        if(sprite != null) {
            Placement.centerHorizontal(sprite);
            box.addAndWatchSprite(sprite);
        }

        if(options.get("quitButtton")) {
            var quitButton:LifecycleButton = new LifecycleButton("interface/close");
            if(options.get("quitEvent") != null) {
                quitButton.setEvent(options.get("quitEvent"), options.get("quitEventOptions"));
            } else {
                quitButton.setHandler(onClose);
            }

            if(sprite != null && options.get("alignQuitToSprite") == true) {
                Placement.placePosition(sprite, quitButton, Position.TOP_MIDDLE_RIGHT_CENTER);
            } else {
                quitButton.setRightX(dialogWidth > Application.SCREEN_WIDTH ? Application.SCREEN_WIDTH : dialogWidth);
                quitButton.setTopY(0);
            }
            box.addAndWatchSprite(quitButton);
        }

        if(options.get("clickToRemove")) {
            addEventListener(MouseEvent.CLICK, onClose);
        }

        addAndWatchSprite(box);

        if(dialogContents != null) {
            setDialogContents(dialogContents);
        }
        initBox();
	}

    private function initBox():Void {
        box.setBehavior(BehaviorUtil.moveTo(box.x, (Application.SCREEN_HEIGHT * options.get("screenPercentY") - dialogHeight*.5), DisplayableField.X_LEFT, 80, Easing.SPRING));
    }

    public function setDialogContents(dialogContents:DialogContents):DialogContents {
        if(this.dialogContents != null) {
            box.removeSprite(this.dialogContents);
        }
        this.dialogContents = dialogContents;
        dialogContents.setDialog(dialog);
        dialogContents.setLeftX(options.get("dialogPaddingX"));
        dialogContents.setTopY(options.get("dialogPaddingY"));
        box.addAndWatchSprite(dialogContents);
        return dialogContents;
    }

    override public function setDialog(dialog:Dialog):Void {
        super.setDialog(dialog);
        if(dialogContents != null) {
            dialogContents.setDialog(dialog);
        }
    }

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        if(dialogContents != null) {
            dialogContents.populate(params);
        }
        if((params.imageName != null || params.sprite != null)) {
            if(sprite != null) {
                box.removeChild(sprite);
            }
            sprite = params.sprite;
            if(params.imageName != null) {
                sprite = Drawing.loadImageSprite(params.imageName);
            }
            //Placement.centerIn(box, sprite);
            box.addChild(sprite);
        }
    }

    override public function start():Void {
        super.start();
        box.setBottomY(0);
        Placement.centerHorizontal(box);
    }
}