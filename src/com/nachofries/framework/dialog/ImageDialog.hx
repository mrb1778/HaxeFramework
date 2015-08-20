package com.nachofries.framework.dialog;
import com.nachofries.framework.lifecycle.LifecycleBitmap;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.Placement;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ImageDialog extends DialogContents {
	private var image:LifecycleBitmap;

	public function new(?imageName:String) {
		super();
        if(imageName != null) {
            setImage(imageName);
        }
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
	}

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        if(params.imageName != null) {
            setImage(params.imageName);
        }
	}
}