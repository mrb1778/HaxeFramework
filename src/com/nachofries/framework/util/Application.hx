package com.nachofries.framework.util;

import openfl.geom.Matrix;
import openfl.display.StageDisplayState;
import openfl.system.Capabilities;
import openfl.Lib;

class Application {
    public static inline var SETTING_APPLICATION:String = "application";

    #if portrait
    public static inline var IDEAL_WIDTH:Float = 480;
    public static inline var IDEAL_HEIGHT:Float = 800;

    public static var SCREEN_WIDTH:Float = 480;
    public static var SCREEN_HEIGHT:Float = 800;
    #else
    private static inline var IDEAL_WIDTH:Float = 800;
    private static inline var IDEAL_HEIGHT:Float = 480;

    public static var SCREEN_WIDTH:Float = 800;
    public static var SCREEN_HEIGHT:Float = 480;
    #end

    public static var SCREEN_SIZE_MIN:Float = 480;

    public static inline var SCREEN_NAME:String = "screen";
    public static var SCREEN_RECTANGLE:Rectangle;
    public static var SCREEN_SIZE:Size;

    public static var SCALE:Float = 1;
    public static var SCALE_WIDTH:Float = 1;
    public static var SCALE_HEIGHT:Float = 1;
    public static inline var SPACER_DEFAULT:Float = 10;
    public static var SPACER:Float = 10;
    public static inline var SCROLLING_DISTANCE_DEFAULT:Float = 40;
    public static var SCROLLING_DISTANCE:Float = 40;
    public static var SCALE_MATRIX:Matrix = new Matrix();

    public static inline var FRAME_RATE:Int = 40;
    public static inline var FRAME_RATE_INVERSE:Float = 1.0/FRAME_RATE;

    public static function initSizes():Void {
        SCREEN_WIDTH = Lib.current.stage.stageWidth;
        SCREEN_HEIGHT = Lib.current.stage.stageHeight;

        //#if ios
        #if openfl_legacy
        SCREEN_WIDTH *= Lib.current.stage.dpiScale;
        SCREEN_HEIGHT *= Lib.current.stage.dpiScale;
        #else
        //trace("Variable: " + Capabilities.screenDPI + ":Capabilities.screenDPI");
        /*SCREEN_WIDTH *= Capabilities.screenDPI;
        SCREEN_HEIGHT *= Capabilities.screenDPI;*/
        #end

        #if portrait
        if(SCREEN_WIDTH > SCREEN_HEIGHT) {
            var tempWidth = SCREEN_HEIGHT;
            SCREEN_HEIGHT = SCREEN_WIDTH;
            SCREEN_WIDTH = tempWidth;
            #if debug
            trace("Switch rotation");
            #end
        }
        #else
        if(SCREEN_HEIGHT > SCREEN_WIDTH) {
            var tempWidth = SCREEN_HEIGHT;
            SCREEN_HEIGHT = SCREEN_WIDTH;
            SCREEN_WIDTH = tempWidth;
            #if debug
            trace("Switch rotation");
            #end
        }
        #end

        SCREEN_SIZE_MIN = Math.min(SCREEN_WIDTH, SCREEN_HEIGHT);
        SCREEN_RECTANGLE = new Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        SCREEN_SIZE = new Size(SCREEN_WIDTH, SCREEN_HEIGHT);

        #if (portrait)
        SCALE = SCREEN_WIDTH / IDEAL_WIDTH;
        #else
        SCALE = SCREEN_HEIGHT / IDEAL_HEIGHT;
        #end

        #if debug
        trace("Screen height: " + SCREEN_HEIGHT);
        trace("Screen width: " + SCREEN_WIDTH);
        trace("Scale: " + SCALE);
        #end

        SCALE_WIDTH = SCREEN_WIDTH / IDEAL_WIDTH;
        SCALE_HEIGHT = SCREEN_HEIGHT / IDEAL_HEIGHT;

        SPACER = SPACER_DEFAULT * SCALE;
        SCROLLING_DISTANCE = SCROLLING_DISTANCE_DEFAULT * SCALE;

        SCALE_MATRIX =  new Matrix();
        SCALE_MATRIX.scale(Application.SCALE, Application.SCALE);
    }

    private static inline function mmToPixels(mm:Float):Int {
        return Math.round(Capabilities.screenDPI * (mm / 25.4));
    }

    private static inline function toggleFullscreen() {
        if(Lib.current.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE){
            Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        } else {
            Lib.current.stage.displayState = StageDisplayState.NORMAL;
        }
    }

    public static inline function getSystemTime():Float {
        #if (html5 || flash)
        return Date.now().getTime();
        #else
        return Sys.time();
        #end
    }
}