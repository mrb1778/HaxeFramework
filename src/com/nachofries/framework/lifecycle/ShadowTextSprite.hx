package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.Placement;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ShadowTextSprite extends TextSprite {
    var frontTextSprite:TextSprite;

	public function new(text:String, size:Int=70, backSize:Int=3, color:Int = 0xffffff, backColor:Int = 0xcccccc, bold:Bool=true) {
		super(text, size + backSize, backColor, bold);
        frontTextSprite = new TextSprite(text, size, color);
        addChild(frontTextSprite);

        frontTextSprite.setCenterX(textField.x + textField.width * .5);
	}
    override public function setText(text:String):Void {
        super.setText(text);
        frontTextSprite.setText(text);
        frontTextSprite.setCenterX(textField.x + textField.width * .5);
    }
}