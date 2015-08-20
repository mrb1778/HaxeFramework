package com.nachofries.framework.spritesheet;
import openfl.display.BitmapData;
import com.nachofries.framework.util.Resources;
import openfl.geom.Point;
import com.nachofries.framework.util.Rectangle;
import com.nachofries.framework.util.Drawing;
import openfl.display.Tilesheet;
import openfl.display.Graphics;

/**
 * ...
 * @author Michael R. Bernstein
 */

class SpriteSheetManager {
    static inline var flags:Int = Tilesheet.TILE_TRANS_2x2 | Tilesheet.TILE_RGB | Tilesheet.TILE_ALPHA;
    public static inline var DATA_LENGTH:Int = 11;

    private static inline var IMAGE_DEFAULT:String = "spritesheet/spritesheet";

    static var images:Map<String, SpriteSheetEntry> = new Map<String, SpriteSheetEntry>();
    static var tileSheet:Tilesheet;
    public static var spriteSheetBitmap:BitmapData;

    public static function loadSpriteSheet():Void {
        #if debug
        spriteSheetBitmap  = Drawing.getBitmapData(IMAGE_DEFAULT, false);
        #else
        spriteSheetBitmap  = new SpriteSheetImage(0, 0);
        #end

        tileSheet = new Tilesheet(spriteSheetBitmap);

        #if debug
        var json:Dynamic = Resources.loadJson("images/" + IMAGE_DEFAULT);
        #else
        var json:Dynamic = CompileTime.parseJsonFile("assets/images/spritesheet/spritesheet.json");
        #end

        var frames:Array<Dynamic> = json.frames;
        var imageCount:Int = 0;
        for (frame in frames) {
            var entry:SpriteSheetEntry = new SpriteSheetEntry();
            entry.index = imageCount++;
            var bounds:Rectangle = new Rectangle(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h);
            entry.bounds = bounds;
            images.set(frame.filename, entry);
            tileSheet.addTileRect(bounds, new Point(bounds.width*.5, bounds.height*.5));
        }
    }
    public static inline function entryExists(name:String):Bool {
        return images.exists(name + Drawing.IMAGE_EXTENSION);
    }
    public static inline function getSpriteSheetEntry(name:String):SpriteSheetEntry {
        return images.get(name + Drawing.IMAGE_EXTENSION);
    }
    public static function getSpriteSheetEntries(name:String, num:Int, ?frameNumbers:Array<Int>):Array<Int> {
        var images:Array<Int> = new Array<Int>();
        for (i in 0...num) {
            var loadFrameNumber:Int = i;
            if(frameNumbers != null) {
                loadFrameNumber = frameNumbers[i];
            }
            var imageName = name + loadFrameNumber;
            var entry:SpriteSheetEntry = getSpriteSheetEntry(imageName);
            images.push(entry.index);
        }
        return images;
    }
    public static inline function render(graphics:Graphics, data:Array<Float>):Void {
        graphics.clear();
        tileSheet.drawTiles(graphics, data, true, flags);
    }
}

@:bitmap("assets/images/spritesheet/spritesheet.png") class SpriteSheetImage extends flash.display.BitmapData {}