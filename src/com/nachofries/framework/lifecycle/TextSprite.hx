package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.SavedSettings;
import openfl.text.Font;
import com.nachofries.framework.util.Resources;
import com.nachofries.framework.util.Application;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TextSprite extends LifecycleSprite {
    private static var defaultFontName:String;

    var textField:TextField;

    public function new(text:String, size:Int=22, color:Int = 0xFDFDFD, bold:Bool=true) {
        super();

        textField = new TextField();

        if (defaultFontName == null) {
            var font = Resources.getDefaultFont();
            defaultFontName = font.fontName;
        }
        textField.defaultTextFormat = new TextFormat(defaultFontName, Math.floor(size*Application.SCALE), color, bold);
        textField.selectable = false;
        textField.mouseEnabled = false;
        textField.autoSize = TextFieldAutoSize.LEFT;

        textField.text = text;
        setName(text);
        addChild(textField);
    }
    public function getText():String {
        return textField.text;
    }
    public function setText(text:String):Void {
        textField.text = text;
        setName(text);
    }
    public function getTextFormat():TextFormat {
        return textField.defaultTextFormat;
    }
    public function setTextFormat(format:TextFormat):Void {
        textField.defaultTextFormat = format;
    }

    public function observeSetting(setting:String):TextSprite {
        SavedSettings.setAndObserve(setting, setText);
        return this;
    }

    override public inline function getWidth():Float { return textField.width; }
    override public inline function getHeight():Float { return textField.height; }
}


/*
class TextSprite extends LifecycleSprite {
    //private var textFormats:Map<String, TextFormat> = new Map<String, TextFormat>();
    //private static var defaultFontName:String;
    private static var defaultFont:Font;

    //var textField:TextField;
    var textField:TextFieldSmooth;

	public function new(text:String, size:Int=22, color:Int = 0xffffff, bold:Bool=true) {
		super();

        //textField = new TextField();


        if (defaultFont == null) {
            defaultFont = Resources.getDefaultFont();
        }

        textField = new TextFieldSmooth("", defaultFont, size*Application.SCALE, color, bold);

        */
/*var textFormatKey:String = "" + size + color + bold;
        var textFormat = textFormats.get(textFormatKey);
        if(textFormat == null) {
            textFormat = new TextFormat(defaultFontName, size*Application.SCALE, color, bold);
            textFormats.set(textFormatKey, textFormat);
        }

        textField.defaultTextFormat = textFormat;
        textField.selectable = false;
        textField.mouseEnabled = false;
        textField.autoSize = TextFieldAutoSize.LEFT;*//*


		textField.text = text;
        setName(text);
		addChild(textField);
	}


*/
/**
 * Creates a text field with appropriate initial values.
 * @param	color The text color. The background will *not* be adjusted
 * to contrast with this (though the background will only be shown for
 * input text fields).
 * @param	fontSize Exactly what it says on the tin.
 * @param	font The name of the font. If specified, embedFonts will be
 * set to true.
 * @param	initialText If specified, this is used to determine the
 * appropriate dimensions. However, width and height both override this.
 * @param	width The width of the text field. If this is specified for
 * a non-input text field, the wordWrap property will be set to true.
 * @param	height The height of the text field.
 * @param	input Whether this is an input text field. If true, the
 * text field will have a white background and black border. If false,
 * the text will not be selectable.
 * @param	align The type weirdness is because TextFormatAlign is a
 * different type of enum on different targets. However, you don't have
 * to worry about that. Just pass "TextFormatAlign.CENTER" or whatever
 * and it will work.
 * @param	wrapAtStageBounds If this is true and the text is wider
 * than the stage width, it will be wrapped to fit onscreen.
 * wrapAtStageBounds is ignored if you specify the width.
 *//*

    public static function createTextField(color:Int,
                                           fontSize:Float,
                                           ?font:String,
                                           ?initialText:String,
                                           ?width:Float,
                                           ?height:Float,
                                           ?input:Bool = false,
                                           ?align: TextFormatAlign,
                                           wrapAtStageBounds:Bool = true):TextField {
        var format:TextFormat = new TextFormat();
        format.font = font;
        format.size = fontSize;
        format.align = align != null ? align : TextFormatAlign.LEFT;
        format.color = color;

        var textField:TextField = new TextField();
        textField.defaultTextFormat = format;
        textField.embedFonts = font != null;
        textField.multiline = true;

        if(input) {
            textField.type = TextFieldType.INPUT;
            textField.background = true;
            textField.border = true;
        } else {
            textField.mouseEnabled = false;
            textField.selectable = false;
        }

        if(width != null) {
            textField.width = width;
            textField.wordWrap = !input;
        }
        if(height != null) {
            textField.height = height;
        }

        if(initialText != null) {
            textField.text = initialText;

            if(width == null) {
                textField.width = textField.textWidth * 1.05;

                if(wrapAtStageBounds && textField.width > Application.SCREEN_WIDTH) {
                    textField.width = Application.SCREEN_WIDTH;
                    textField.wordWrap = true;
                }
            }
            if(height == null) {
                textField.height = textField.textHeight * 1.1;
            }
        }

        return textField;
    }


    public function getText():String {
        return textField.text;
    }
    public function setText(text:String):Void {
        textField.text = text;
        setName(text);
    }
    */
/*public function getTextFormat():TextFormat {
        return textField.defaultTextFormat;
    }
    public function setTextFormat(format:TextFormat):Void {
        textField.defaultTextFormat = format;
    }*//*

}*/
