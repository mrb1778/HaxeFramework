package com.nachofries.framework.util;

/**
 * ...
 * @author Michael R. Bernstein
 */
import haxe.macro.Expr.ExprOf;
import haxe.Json;
import haxe.macro.Context;

class MacroUtils {
    macro static public function getLevelsPerFile(fileName:String):ExprOf<Array<Int>> {
        var resultArray:Array<Int> = [];
        try {
            var i=1;
            var fileContents:String = null;
            do {
                fileContents = loadFileAsString(fileName + (i == 1 ? "" : i+"") + ".json");
                if(fileContents != null) {
                    var configuration = Json.parse(fileContents);
                    resultArray.push(configuration.levels.length);
                }
                i++;
            } while(fileContents != null);
        } catch(e:Dynamic) {
            trace("Invalid level Chooser Screen config: " + e);
        }
        return Context.makeExpr(resultArray, Context.currentPos());
    }

    macro static public function parseJsonFiles(fileName:String, zeroIndexed:Bool=true):ExprOf<Array<Dynamic>> {
        var resultArray:Array<Dynamic> = [];
        try {
            var i= zeroIndexed ? 0 : 1;
            var fileContents:String = null;
            do {
                fileContents = loadFileAsString(fileName + (zeroIndexed ? i+"" : (i == 1 ? "" : i +"")) + ".json");
                if(fileContents != null) {
                    var configuration = Json.parse(fileContents);
                    resultArray.push(configuration);
                }
                i++;
            } while(fileContents != null);
        } catch(e:Dynamic) {
            trace("Invalid json file: " + e);
        }
        return Context.makeExpr(resultArray, Context.currentPos());
    }

    macro static public function parseJsonFilesAsString(fileName:String, zeroIndexed:Bool=true):ExprOf<Array<String>> {
        var resultArray:Array<Dynamic> = [];
        try {
            var i= zeroIndexed ? 0 : 1;
            var fileContents:String = null;
            do {
                fileContents = loadFileAsString(fileName + (zeroIndexed ? i+"" : (i == 1 ? "" : i +"")) + ".json");
                if(fileContents != null) {
                    Json.parse(fileContents);
                    resultArray.push(fileContents);
                }
                i++;
            } while(fileContents != null);
        } catch(e:Dynamic) {
            trace("Invalid json file: " + e);
        }
        return Context.makeExpr(resultArray, Context.currentPos());
    }

    macro static public function countFiles(fileName:String, zeroIndexed:Bool=true, verifyJson:Bool=true):ExprOf<Int> {
        var size:Int = 0;
        try {
            var i= zeroIndexed ? 0 : 1;
            var fileContents:String = null;
            do {
                fileContents = loadFileAsString(fileName + (zeroIndexed ? i+"" : (i == 1 ? "" : i +"")) + ".json");
                if(fileContents != null) {
                    if(verifyJson) {
                        Json.parse(fileContents);
                    }
                    i++;
                    size++;
                }
            } while(fileContents != null);
        } catch(e:Dynamic) {
            trace("Invalid file in count: " + e);
        }
        return Context.makeExpr(size, Context.currentPos());
    }

    #if macro
    static function loadFileAsString(path:String) {
        try {
            var p = Context.resolvePath(path);
            Context.registerModuleDependency(Context.getLocalModule(), p);
            return sys.io.File.getContent(p);
        } catch(e:Dynamic) {
            return null;
        }
    }
    #end
}