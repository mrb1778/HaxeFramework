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

    public static var IMAGE_DEFAULT:String = "spritesheet/spritesheet";

    static var images:Map<String, SpriteSheetEntry> = new Map<String, SpriteSheetEntry>();
    static var tileSheet:Tilesheet;
    public static var spriteSheetBitmap:BitmapData;


    public static function loadSpriteSheet(?name:String):Void {
        if(name == null) {
            name = IMAGE_DEFAULT;
        }
        spriteSheetBitmap  = Drawing.getBitmapData(name, false);
        tileSheet = new Tilesheet(spriteSheetBitmap);

        var json:Dynamic = Resources.loadJson("images/" + name);

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