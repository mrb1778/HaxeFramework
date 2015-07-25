package com.nachofries.framework.spritesheet;

import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.SavedSettings;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.spritesheet.SpriteSheetSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TextSpriteSheetSprite extends SpriteSheetSprite {
    private var text:String;
    private var style:String;
    private var spriteSheetIndexes:Array<Int>;
    private var charWidth:Float;
    private var charHeight:Float;
    private var modeRegEx:EReg;

    public static inline function create(text:String, ?style:String, ?modeRegEx:String):TextSpriteSheetSprite {
        var sprite:TextSpriteSheetSprite = Pooling.get(ClassInfo.getClassName());
        if(sprite == null) {
            sprite = new TextSpriteSheetSprite();
        }
        sprite.populate(text, style, modeRegEx);
        return sprite;
    }

    private function populate(?text:String, ?style:String, ?modeRegEx:String):Void {
        this.style = style;
        init(text);
        this.text = text;
        charWidth = width;
        charHeight = height;
        width = charWidth * text.length;

        spriteSheetIndexes = new Array<Int>();
        for(i in 0...text.length) {
            spriteSheetIndexes[i] = SpriteSheetManager.getSpriteSheetEntry(text.charAt(i)).index;
        }

        if(modeRegEx != null) {
            this.modeRegEx = new EReg(modeRegEx, null);
        } else {
            this.modeRegEx = null;
        }
    }

    override public function init(?text:String):Void {
        super.init(getEntryName(text.charAt(0)));
    }

    override public function setMode(?mode:String, persist:Bool = true):Void {
        super.setMode(mode, persist);
        if(modeRegEx != null) {
            if(modeRegEx.match(mode)) {
                setText(mode);
            }
        }
    }

    public function setText(text:String):Void {
        this.text = text;
        if(text.length != spriteSheetIndexes.length) {
            width = charWidth * text.length;
            spriteSheetIndexes = new Array<Int>();
        }
        for(i in 0...text.length) {
            spriteSheetIndexes[i] = SpriteSheetManager.getSpriteSheetEntry(getEntryName(text.charAt(i))).index;
        }
    }

    public function observeSetting(setting:String):TextSpriteSheetSprite {
        SavedSettings.setAndObserve(setting, setText);
        return this;
    }

    private inline function getEntryName(char:String):String {
        if(style != null) {
            return style + "-" + char;
        } else {
            return char;
        }
    }

    override public function render():Void {
        if(spriteSheetLayer != null) {
            for(i in 0...spriteSheetIndexes.length) {
                spriteSheetLayer.renderSprite(
                    x+i*charWidth * Application.SCALE,
                    y,
                    charWidth, charHeight,
                    spriteSheetIndexes[i],
                    scaleX * Application.SCALE, scaleY * Application.SCALE,
                    rotation,
                    alpha,
                    red, green, blue,
                    flipY, flipY);
            }
        }
    }

    override public function destroy():Void {
        super.destroy();
        if(behavior != null) {
            behavior.destroy();
            behavior = null;
        }
        Pooling.recycle(this);
    }
}