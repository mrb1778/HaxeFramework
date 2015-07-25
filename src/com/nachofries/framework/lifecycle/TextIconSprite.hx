package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.SavedSettings;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Position;
import com.nachofries.framework.util.Drawing;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TextIconSprite extends LifecycleSpriteWatcher {
    var iconBitmap:LifecycleBitmap;
    var textSprite:TextSprite;
    var posistion:Position;
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    var setting:String;

	public function new(icon:String, text:String="", ?posistion:Position, offsetX:Float=0, offsetY:Float=0, textSize:Int=22, textColor:Int = 0xffffff, textBold:Bool=true) {
        super();

        iconBitmap = Drawing.loadImage(icon);
        addChild(iconBitmap);
        textSprite = new TextSprite(text, textSize, textColor, textBold);
        addChild(textSprite);

        if(posistion == null) {
            posistion = Position.MIDDLE_CENTER;
        }
        this.posistion = posistion;

        this.offsetX = offsetX;
        this.offsetY = offsetY;

        setText(text);
    }

    public function setText(value:Dynamic):Void {
        textSprite.setText(Std.string(value));
        Placement.placePosition(iconBitmap, textSprite, posistion, offsetX, offsetY);
    }

    public function observeSetting(setting:String):TextIconSprite {
        SavedSettings.setAndObserve(setting, setText);
        return this;
    }
}