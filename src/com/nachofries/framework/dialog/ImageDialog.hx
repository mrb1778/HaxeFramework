package com.nachofries.framework.dialog;
import com.nachofries.framework.lifecycle.LifecycleBitmap;
import com.nachofries.framework.tween.Easing;
import com.nachofries.framework.tween.Tween;
import com.nachofries.framework.util.DialogHandler;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.Settings;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ImageDialog extends DialogContents {
	private var onCompleteHandler:DialogHandler;
	private var image:LifecycleBitmap;
    var dialogTween:Tween;

	public function new(?imageName:String) {
		super();

        var quitButton = Drawing.loadImage("interface/ok-button");
        Placement.centerHorizontal(quitButton);
        Placement.alignBottom(quitButton, Application.SPACER*3);
        addChild(quitButton);
        addEventListener(MouseEvent.MOUSE_DOWN, onClose);
        dialogTween = Tween.create(Easing.SPRING, 180);

        if(imageName != null) {
            setImage(imageName);
        }
    }

    override public function reset():Void {
        super.reset();
        dialogTween.reset();
    }


    public function setImage(imageName:String):Void {
        if(image == null) {
            image = Drawing.loadImage(imageName);
            addChild(image);
        } else {
            image.loadBitmapData(imageName);
        }

        Placement.centerHorizontal(image);
        Placement.centerVertical(image);
        image.setAlpha(0);
	}

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        setImage(params.imageName);
	}
}