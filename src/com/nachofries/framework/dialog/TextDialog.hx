package com.nachofries.framework.dialog;
import com.nachofries.framework.lifecycle.TextSprite;
import com.nachofries.framework.util.DialogHandler;
import com.nachofries.framework.util.Placement;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TextDialog extends DialogContents {
	private var onCompleteHandler:DialogHandler;
	private var textSprite:TextSprite;

	private function new(text:String="") {
		super();

        textSprite = new TextSprite(text);
        Placement.centerHorizontal(textSprite);
        addChild(textSprite);
    }

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        if(params != null && params.text != null) {
            textSprite.setText(params.text);
            Placement.centerHorizontal(textSprite);
        }
	}
}