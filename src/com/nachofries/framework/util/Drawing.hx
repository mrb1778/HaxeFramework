package com.nachofries.framework.util;
#if (cpp || neko)
import sys.io.FileOutput;
import openfl.utils.ByteArray;
#end
import openfl.display.PNGEncoderOptions;

import com.nachofries.framework.util.NumberUtils;
import openfl.display.JointStyle;
import openfl.display.CapsStyle;
import openfl.display.GraphicsPathCommand;
import openfl.Vector;
import com.nachofries.framework.lifecycle.LifecycleBitmap;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;

import openfl.Assets;

class Drawing {
    private static inline var IMAGE_LOCATION:String = Resources.ASSETS_LOCATION + "images/";
    public static inline var IMAGE_EXTENSION:String = ".png";
    public static inline var MARKER_GRADIENT_LINEAR:String = "linear-gradient";
    public static inline var MARKER_GRADIENT_RADIAL:String = "radial-gradient";
    public static inline var MARKER_FILL:String = "fill:";

    private static var commands:Vector<Int> = new Vector<Int>();
    private static var data:Vector<Float> = new Vector<Float>();

    private static var bitmapAlias:Map<String, String> = new Map<String, String>();

    public static inline function addBitMapAlias(name:String, alias:String):Void {
        bitmapAlias.set(name, alias);
    }

    public static inline function getBitmapData(name:String, cache:Bool=true):BitmapData {
        if(bitmapAlias.exists(name)) {
            name = bitmapAlias.get(name);
        }
        return Assets.getBitmapData(IMAGE_LOCATION + name + IMAGE_EXTENSION, cache);
    }

    public static inline function getImageSize(name:String, scale:Bool=true):Size {
        var backgroundImage:BitmapData = getBitmapData(name);
        if(scale) {
            return new Size(backgroundImage.width*Application.SCALE, backgroundImage.height*Application.SCALE);
        } else {
            return new Size(backgroundImage.width, backgroundImage.height);
        }
    }
    public static inline function loadImage(name:String, cache:Bool=true):LifecycleBitmap {
        var bitmap:LifecycleBitmap = new LifecycleBitmap(getBitmapData(name, cache));
        bitmap.setName(name);
        bitmap.setScale(1);
        return bitmap;
    }
    public static inline function loadImageSprite(name:String, cache:Bool=true):LifecycleSprite {
        var sprite:LifecycleSprite = new LifecycleSprite();
        sprite.setName(name);
        sprite.mouseEnabled = false;
        sprite.mouseChildren = false;
        var bitmap:LifecycleBitmap = loadImage(name, cache);
        sprite.addChild(bitmap);
        return sprite;
    }
    public static inline function createFilledSprite(image:String, width:Float, height:Float=0):LifecycleSprite  {
        var sprite = new LifecycleSprite();
        sprite.setName(image);
        fillBox(sprite.graphics, image, 0, 0, width, height);
        return sprite;
    }

    public static inline function rotateImage(displayObject:DisplayObject, angleDegrees:Float):Void {
        var m:Matrix=displayObject.transform.matrix.clone();

        var x:Float = displayObject.width / 2;
        var y:Float = displayObject.height / 2;


        var point:Point = new Point(x, y);
        point=m.transformPoint(point);
        m.tx-=point.x;
        m.ty-=point.y;
        m.rotate(angleDegrees * (Math.PI / 180));
        m.tx+=point.x;
        m.ty+=point.y;

        displayObject.transform.matrix=m;
    }


/*public static inline function rotateImage(object:DisplayObject, degrees:Float):Void {
        var point:Point=new Point(object.x + object.width * .5, object.y + object.height * .5);

        var matrix:Matrix=object.transform.matrix;
        matrix.tx -= point.x;
        matrix.ty -= point.y;
        matrix.rotate (degrees*(Math.PI/180.0));
        matrix.tx += point.x;
        matrix.ty += point.y;
        object.transform.matrix=matrix;
        *//*var radians:Float = degrees * (Math.PI / 180.0);
        var offsetWidth:Float = object.width * .5;
        var offsetHeight:Float =  object.height * .5;

        // Perform rotation
        var matrix:Matrix = new Matrix();
        matrix.translate(-offsetWidth, -offsetHeight);
        matrix.rotate(radians);
        matrix.translate(offsetWidth, offsetHeight);
        matrix.concat(object.transform.matrix);
        object.transform.matrix = matrix;*//*
    }*/

    public static inline function resetMatrix(obj:DisplayObject):Void {
        obj.transform.matrix = new Matrix();
    }

    public static inline function beginStyle(graphics:Graphics, background:String, ?matrix:Matrix, fillLine:Bool=false, lineThickness:Float=5, ?width:Float, ?height:Float, x:Float=0, y:Float=0):Size {
        background = StringTools.trim(background);
        background = StringTools.replace(background, "#", "0x");
        if(StringTools.startsWith(background, MARKER_GRADIENT_LINEAR) || StringTools.startsWith(background, MARKER_GRADIENT_RADIAL)) {
            var gradientType:GradientType;
            if(StringTools.startsWith(background, MARKER_GRADIENT_LINEAR)) {
                background = background.substring(MARKER_GRADIENT_LINEAR.length+1, background.length - 1);
                gradientType = GradientType.LINEAR;
            } else {
                background = background.substring(MARKER_GRADIENT_RADIAL.length+1, background.length - 1);
                gradientType = GradientType.RADIAL;
            }
            background = StringTools.trim(background);
            var argsStr:Array<String> = background.split(",");

            var angle:Float = 0;
            var angleStr:String = StringTools.trim(argsStr.shift());
            if(angleStr == "top") {
                angle = Math.PI * .5;
            } else if(angleStr == "bottom") {
                angle = Math.PI;
            } else if(angleStr == "left") {
                angle = 0;
            } else if(StringTools.endsWith(angleStr, "deg")) {
                angle = NumberUtils.degreesToRadians(Std.parseFloat(angleStr.substr(0, angleStr.length-3)));
            } else {
                angle = Std.parseFloat(angleStr);
            }

            var colors:Array<Int> = [];
            var ratios:Array<Dynamic> = [];
            var alphas:Array<Dynamic> = [];

            var ratioIncrement:Int = Std.int(255 / argsStr.length);
            var count:Int = 0;

            for(colorArg in argsStr) {
                colorArg = StringTools.trim(colorArg);
                var colorPercent:Array<String> = colorArg.split(" ");
                var color:String = colorPercent[0];
                if(color.length == 10) {
                    colors.push(Std.parseInt(color.substr(0, 8)));
                    alphas.push(Std.parseInt("0x" + color.substr(8, 10)) / 255.0);
                } else {
                    colors.push(Std.parseInt(color));
                    alphas.push(1);
                }
                if(colorPercent.length > 1) {
                    var percentStr:String = colorPercent[1];
                    percentStr = percentStr.substr(0, percentStr.length-1);
                    ratios.push(Std.parseFloat(percentStr)/100.0 * 255);
                } else {
                    ratios.push(count * ratioIncrement);
                }
                count++;
            }
            if(matrix == null) {
                matrix = new Matrix();
                matrix.createGradientBox(width != 0 ? width : Application.SCREEN_WIDTH, height != 0 ? height : Application.SCREEN_HEIGHT, angle, x, y);
            }

            if(fillLine) {
                graphics.lineStyle(lineThickness, CapsStyle.ROUND, JointStyle.ROUND);
                graphics.lineGradientStyle(gradientType,
                                           colors,
                                           alphas,
                                           ratios,
                                           matrix,
                                           SpreadMethod.PAD,
                                           InterpolationMethod.RGB,
                                           0);
            } else {
                graphics.beginGradientFill(gradientType,
                                           colors,
                                           alphas,
                                           ratios,
                                           matrix,
                                           SpreadMethod.PAD,
                                           InterpolationMethod.RGB,
                                           0);
            }
            return Application.SCREEN_SIZE;
        } else if(StringTools.startsWith(background, "0x")) {
            var color:UInt;
            var alpha:Float;
            if(background.length == 10) {
                color = Colorize.parseColor(background.substr(0, 8));
                alpha = Colorize.parseColor("0x" + background.substr(8, 10)) / 255.0;
            } else {
                color = Colorize.parseColor(background);
                alpha = 1;
            }

            if(fillLine) {
                graphics.lineStyle(lineThickness, color, alpha, CapsStyle.ROUND, JointStyle.ROUND);
            } else {
                graphics.beginFill(color, alpha);
            }
            return Application.SCREEN_SIZE;
        } else {
            var backgroundImage:BitmapData = getBitmapData(background);
            if(matrix == null) {
                matrix = Application.SCALE_MATRIX;
            }
            if(fillLine) {
                graphics.lineStyle(lineThickness, CapsStyle.ROUND, JointStyle.ROUND);
                graphics.lineBitmapStyle(backgroundImage, matrix, true, true);
            } else {
                graphics.beginBitmapFill(backgroundImage, matrix, true, true);
            }
            return new Size(backgroundImage.width*Application.SCALE, backgroundImage.height*Application.SCALE);
        }
	}

    public static inline function endStyle(graphics:Graphics):Void {
        graphics.endFill();
        graphics.lineStyle();
    }
    
    
	public static inline function fillSprite(sprite:Sprite, background:String, paddingX:Float=0, paddingY:Float=0, radius:Float=0):Void {
        fillBox(sprite.graphics, background, 0, 0, sprite.width+paddingX, sprite.height+paddingY, radius);
    }
    public static inline function fillBox(graphics:Graphics, background:String, x:Float=0, y:Float=0, width:Float=0, height:Float=0, radius:Float=0, down:Bool=false, up:Bool=false, fitXUnder:Bool=false, fitYUnder:Bool=false, fitXOver:Bool=false, fitYOver:Bool=false):Void {
        var imageSize:Size = beginStyle(graphics, background, null, false, 0, width, height, x, y);
        if(width == 0) {
            width = imageSize.getWidth();
        } else if(fitXUnder) {
            width = Math.floor(width/imageSize.getWidth()) * imageSize.getWidth();
        } else if(fitXOver) {
            width = Math.ceil(width/imageSize.getWidth()) * imageSize.getWidth();
        }

        if(height == 0) {
            height = imageSize.getHeight();
        } else if(fitYUnder) {
            height = Math.floor(height/imageSize.getHeight()) * imageSize.getHeight();
        } else if(fitYOver) {
            height = Math.ceil(height/imageSize.getHeight()) * imageSize.getHeight();
        }

        if(down) {
            y += height;
        }
        if(up) {
            y -= height;
        }
        if(radius != 0) {
            graphics.drawRoundRect(0,0,width,height,radius,radius);
        } else {
            graphics.drawRect(x, y, width, height);
            /*var xWidth:Float = x + width;
            var yHeight:Float = y + height;

            var verticies:Vector<Float> = new Vector<Float>();
            verticies.push(x);
            verticies.push(y);

            verticies.push(x);
            verticies.push(yHeight);

            verticies.push(xWidth);
            verticies.push(yHeight);

            verticies.push(x);
            verticies.push(y);

            verticies.push(xWidth);
            verticies.push(y);

            verticies.push(xWidth);
            verticies.push(yHeight);

            graphics.drawTriangles(verticies);*/
        }
        endStyle(graphics);
	}
	public static inline function fillScreen(parent:Sprite, background:String, stretch:Bool=false):Void {
        if(StringTools.startsWith(background, MARKER_FILL)) {
            background = background.substring(MARKER_FILL.length, background.length - 1);
            fillBox(parent.graphics, background, 0, 0, Application.SCREEN_WIDTH, Application.SCREEN_HEIGHT);
        } else if(stretch) {
            var backgroundObject:DisplayObject = loadImage(background);
            backgroundObject.width = Application.SCREEN_WIDTH;
            backgroundObject.height = Application.SCREEN_HEIGHT;
            parent.addChild(backgroundObject);
        } else {
            fillBox(parent.graphics, background, 0, 0, Application.SCREEN_WIDTH, Application.SCREEN_HEIGHT);
        }
	}
    public static inline function fillScreenHorizontal(parent:Sprite, background:String, alignBottom:Bool=true):Void {
        fillBox(parent.graphics, background, 0, 0, Application.SCREEN_WIDTH, 0, false);
	}
    public static inline function centerOnScreen(parent:LifecycleSprite, background:String, cache=true):LifecycleBitmap {
		var background:LifecycleBitmap = loadImage(background, cache);
        if(background != null) {
            parent.addChild(background);
            Placement.center(background);
        }
        return background;
	}
	public static inline function moveTo(x:Float, y:Float):Void {
        commands.push(GraphicsPathCommand.MOVE_TO);
        data.push(x);
        data.push(y);
    }
    public static inline function lineTo(x:Float, y:Float):Void {
        commands.push(GraphicsPathCommand.LINE_TO);
        data.push(x);
        data.push(y);
    }
    public static inline function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
        commands.push(GraphicsPathCommand.CURVE_TO);
        data.push(controlX);
        data.push(controlY);
        data.push(anchorX);
        data.push(anchorY);
    }
    public static inline function cubicCurveTo(controlX:Float, controlY:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
        commands.push(GraphicsPathCommand.CUBIC_CURVE_TO);
        data.push(controlX);
        data.push(controlY);
        data.push(controlX2);
        data.push(controlY2);
        data.push(anchorX);
        data.push(anchorY);
    }
    public static inline function drawPath(graphics:Graphics):Void {
        graphics.drawPath(commands, data);
        /*commands = commands.splice(0, commands.length);
        data = data.splice(0, data.length);*/
        commands = new Vector<Int>();
        data = new Vector<Float>();
    }


	/*public static inline function drawBox(graphics:Graphics, x:Float=0, y:Float=0, width:Float=0, height:Float=0, ?background:String):Void {
        trace("x: " + x + " y:" + y + " width:" + width + " height " + height);
        if(background != null) {
            beginFill(graphics, background);
        }

        var verticies:Vector<Float> = new Vector<Float>();
        verticies.push(x);
        verticies.push(y);

        verticies.push(x+width);
        verticies.push(y);

        verticies.push(x+width);
        verticies.push(y+height);

        verticies.push(x);
        verticies.push(y+height);

        var indicies:Vector<Int> = new Vector<Int>();
        indicies.push(0);
        indicies.push(1);
        indicies.push(2);

        indicies.push(0);
        indicies.push(2);
        indicies.push(3);
        graphics.drawTriangles(verticies, indicies);


        if(background != null) {
            endStyle(graphics);
        }
    }*/


	public static inline function fillLine(graphics:Graphics, vertices:Array<Point>, thickness:Float, background:String, x:Float=0, y:Float=0, ?deltaMode:Bool=false):Void {
        beginStyle(graphics, background, true, thickness);
        y -= thickness *.5;
        var first:Bool = true;
        for (vertex in vertices) {
            if(first) {
                moveTo(vertex.x + x, vertex.y + y);
                first = false;
            } else {
                lineTo(vertex.x + x, vertex.y + y);
            }
		}
        drawPath(graphics);
        endStyle(graphics);
	}

    public static inline function fillDeltaLine(graphics:Graphics, vertices:Array<Point>, thickness:Float, background:String, x:Float=0, y:Float=0):Void {
        var matrix:Matrix = new Matrix();
        //matrix.scale(Application.SCALE, Application.SCALE);

		var lineX:Float = x;
		var lineY:Float = y;

		var lastX:Float = 0;
        var lastY:Float = 0;
        var lastRotation:Float = 0;
        var rotation:Float = 0;

        var i:Int = 0;
        beginStyle(graphics, background, true, thickness);
        y -= thickness *.5;
        var first:Bool = true;
        for (vertex in vertices) {
            /*if(first) {
                moveTo(vertex.x + x, vertex.y + y);
                first = false;
            } else {
                lineTo(vertex.x + x, vertex.y + y);
            }*/

            lineX += vertex.x;
            lineY -= vertex.y;
            if(i++ > 0) {
                rotation = NumberUtils.angleBetween(lastX, lastY, lineX, lineY);
                matrix.rotate(-lastRotation);
                matrix.rotate(rotation);

                beginStyle(graphics, background, matrix);
                moveTo(lastX, lastY + thickness);
                lineTo(lastX, lastY);
                lineTo(lineX, lineY);
                lineTo(lineX, lineY + thickness);
                drawPath(graphics);

                endStyle(graphics);
            }

            lastX = lineX;
            lastY = lineY;
            lastRotation = rotation;
		}
        drawPath(graphics);
        endStyle(graphics);
	}
    public static inline function fillDeltaPolygon(graphics:Graphics, vertices:Array<Point>, background:String, x:Float=0, y:Float=0):Void {
        var lineX:Float = x;
		var lineY:Float = y;

        var height:Float = 0;
        beginStyle(graphics, background);
        moveTo(x, y);
        for (vertex in vertices) {
            lineX += vertex.x;
            lineY -= vertex.y;
            lineTo(lineX, lineY);
		}

        lineTo(lineX, y);
        drawPath(graphics);
        endStyle(graphics);
	}

    public static inline function drawPolygon(graphics:Graphics, vertices:Array<Point>, x:Float=0, y:Float=0, ?background:String):Void {
        if(background != null) {
            beginStyle(graphics, background);  //todo: add size info?
        }
        var first:Bool = true;
        for (vertex in vertices) {
            if(first) {
                moveTo(vertex.x + x, vertex.y + y);
                first = false;
            } else {
                lineTo(vertex.x+x, vertex.y+y);
            }
        }
        drawPath(graphics);
        if(background != null) {
            endStyle(graphics);
        }
    }

    public static inline function fillExceptHole(graphics:Graphics, background:String, x:Float, y:Float, radius:Float):Void {
        var topBorder:Float = y-radius;
        /*if(topBorder < 0) {
            topBorder = 0;
        }*/
        var leftBorder:Float = x-radius;
        /*if(leftBorder < 0) {
            leftBorder = 0;
        }*/
        var rightBorder:Float = x+radius;
        /*if(rightBorder > Application.SCREEN_WIDTH) {
            rightBorder = Application.SCREEN_WIDTH;
        }*/
        var bottomBorder:Float = y+radius;
        /*if(bottomBorder > Application.SCREEN_HEIGHT) {
            bottomBorder = Application.SCREEN_HEIGHT;
        }*/

        //top
        beginStyle(graphics, background); //todo: add size info, add size info to method?
        moveTo(-radius, -radius); //1
        lineTo(Application.SCREEN_WIDTH + radius, -radius); //2
        lineTo(Application.SCREEN_WIDTH + radius, y); //3
        lineTo(rightBorder, y); //4
        circleSegment(graphics, x, y, 0, -Math.PI, radius);
        lineTo(-radius, y); //7
        lineTo(-radius, -radius); //1
        drawPath(graphics);

        //bottom
        moveTo(-radius, y); //1
        lineTo(-radius, Application.SCREEN_HEIGHT + radius); //7
        lineTo(Application.SCREEN_WIDTH + radius, Application.SCREEN_HEIGHT + radius); //6
        lineTo(Application.SCREEN_WIDTH + radius, y); //5
        lineTo(rightBorder, y); //2
        circleSegment(graphics, x, y, 0, Math.PI, radius);
        lineTo(-radius, y); //1
        drawPath(graphics);
        endStyle(graphics);

    }

    private static inline var BLEND_MASK1:Int = 0xff00ff;
    private static inline var BLEND_MASK2:Int = 0x00ff00;
    public static inline function blendColors(color1:Int, color2:Int, amount:Float ):Int {
        var f2:Int = cast(256 * amount, Int);
        var f1:Int = 256 - f2;
        return ((((( color1 & BLEND_MASK1 ) * f1 ) + ( ( color2 & BLEND_MASK1 ) * f2 )) >> 8 ) & BLEND_MASK1 ) | ((((( color1 & BLEND_MASK2 ) * f1 ) + ( ( color2 & BLEND_MASK2 ) * f2 )) >> 8 ) & BLEND_MASK2 );
    }

    public static inline function rotate(target:DisplayObject,?angle:Float=45,?rotationPoint:Point):Void {
        if (rotationPoint==null) {
            rotationPoint = new Point(0,0);
        }
        target.transform.matrix = rotateMatrix(target,angle,rotationPoint);
    }

    public static inline function rotateCenter(target:DisplayObject,?angle:Float=45):Void {
        rotate(target,angle, new Point(target.width*.5, target.height*.5));
    }

    public static inline function rotateMatrix(target:DisplayObject, angle:Float, rotationPoint:Point):Matrix {
        var matrix:Matrix = new Matrix();
        //var matrix:Matrix = target.transform.matrix.clone();
        //rotationPoint=matrix.transformPoint(rotationPoint);
        matrix.translate(-rotationPoint.x, -rotationPoint.y);
        matrix.rotate(angle * (Math.PI / 180.0));
        matrix.translate(rotationPoint.x, rotationPoint.y);
        matrix.concat(target.transform.matrix);
        return matrix;
    }

    private static var _DEG2RAD:Float = Math.PI/180;

    public static inline function skew(target:DisplayObject, skewXDegree:Float, skewYDegree:Float):Void {
        var m:Matrix = target.transform.matrix.clone();
        m.b = Math.tan(skewYDegree*_DEG2RAD);
        m.c = Math.tan(skewXDegree*_DEG2RAD);
        target.transform.matrix = m;
    }

    public static inline function skewY(target:DisplayObject, skewDegree:Float):Void {
        var m:Matrix = target.transform.matrix.clone();
        m.b = Math.tan(skewDegree*_DEG2RAD);
        target.transform.matrix = m;
    }

    public static inline function skewX(target:DisplayObject, skewDegree:Float):Void {
        var m:Matrix = target.transform.matrix.clone();
        m.c = Math.tan(skewDegree*_DEG2RAD);
        target.transform.matrix = m;
    }


    public static inline function drawQuadrilateral(graphics:Graphics, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float, background:String):Void {
        beginStyle(graphics, background);
        moveTo(x1, y1);
        lineTo(x2, y2);
        lineTo(x3, y3);
        lineTo(x4, y4);
        drawPath(graphics);
        endStyle(graphics);
  }


    /**
     * Draw a segment of a circle
     * @param graphics      the graphics object to draw into
     * @param center        the center of the circle
     * @param start         start angle (radians)
     * @param end           end angle (radians)
     * @param r             radius of the circle
     * @param h_ratio       horizontal scaling factor
     * @param v_ratio       vertical scaling factor
     * @param new_drawing   if true, uses a moveTo call to start drawing at the start point of the circle; else continues drawing using only lineTo and curveTo
     *
     */
    public static inline var CIRCLE_SEGMENTS:Int = 40;
    public static inline function circleSegment(graphics:Graphics, x:Float,y:Float, start:Float, end:Float, r:Float, ?h_ratio:Float=1, ?v_ratio:Float=1, ?new_drawing:Bool=false):Void {
        // first point of the circle segment
        if(new_drawing) {
            moveTo(x+Math.cos(start)*r*h_ratio, y+Math.sin(start)*r*v_ratio);
        }

        var theta:Float = (end-start)/CIRCLE_SEGMENTS; //todo: num segments relates to angle
        var angle:Float = start; // start drawing at angle ...

        var ctrlRadius:Float = r/Math.cos(theta/2); // this gets the radius of the control point
        for (i in 0...CIRCLE_SEGMENTS) {
            // increment the angle
            angle += theta;
            var angleMid:Float = angle-(theta/2);
            // calculate our control point
            var cx:Float = x+Math.cos(angleMid)*(ctrlRadius*h_ratio);
            var cy:Float = y+Math.sin(angleMid)*(ctrlRadius*v_ratio);
            // calculate our end point
            var px:Float = x+Math.cos(angle)*r*h_ratio;
            var py:Float = y+Math.sin(angle)*r*v_ratio;
            // draw the circle segment
            curveTo(cx, cy, px, py);
        }

    }

    public function saveImage(image:BitmapData, outputFile:String):Void
    {
        #if (cpp || neko)

        var path;
        // path = Sys.getCwd();
        // path = path.substr(0, path.indexOf('Export')) + "test2.png";

        path = outputFile;

        #if openfl_legacy
        var imageData:ByteArray = image.encode('png', 1);
        #else
        var imageData:ByteArray = image.encode(image.rect, PNGEncoderOptions);
        #end

        var fo:FileOutput = sys.io.File.write(path, true);
        try {

            fo.writeBytes(imageData, 0, imageData.length );

            #if openfl_legacy
            // fo.writeBytes(imageData, 0, imageData.length );
            #else
            // fo.writeBytes(imageData, 0, imageData.length );
            #end

            trace( "save path done: " + path );
        } catch (e:Dynamic){
            trace("Error writing file " + path + ": " + e);
        }
        fo.close();
        #end
    }

    /*public static inline function drawSegment(graphics:Graphics, background:String, width, lanes, x1, y1, w1, x2, y2, w2, fog):Void {

    var r1 = Render.rumbleWidth(w1, lanes),
        r2 = Render.rumbleWidth(w2, lanes),
        l1 = Render.laneMarkerWidth(w1, lanes),
        l2 = Render.laneMarkerWidth(w2, lanes),
        lanew1, lanew2, lanex1, lanex2, lane;

    ctx.fillStyle = color.grass;
    ctx.fillRect(0, y2, width, y1 - y2);

    Render.polygon(ctx, x1-w1-r1, y1, x1-w1, y1, x2-w2, y2, x2-w2-r2, y2, color.rumble);
    Render.polygon(ctx, x1+w1+r1, y1, x1+w1, y1, x2+w2, y2, x2+w2+r2, y2, color.rumble);
    Render.polygon(ctx, x1-w1,    y1, x1+w1, y1, x2+w2, y2, x2-w2,    y2, color.road);

    if (color.lane) {
      lanew1 = w1*2/lanes;
      lanew2 = w2*2/lanes;
      lanex1 = x1 - w1 + lanew1;
      lanex2 = x2 - w2 + lanew2;
      for(lane = 1 ; lane < lanes ; lanex1 += lanew1, lanex2 += lanew2, lane++)
        Render.polygon(ctx, lanex1 - l1/2, y1, lanex1 + l1/2, y1, lanex2 + l2/2, y2, lanex2 - l2/2, y2, color.lane);
    }

    Render.fog(ctx, 0, y1, width, y2-y1, fog);
  }*/



    /*static public function drawStar(
        g:Graphics, // Graphics object to draw in, could be Shape, Sprite, MovieClip, etc.
        x:Int, // x-coordinate of center point (the middle of the star)
        y:Int, // y-coordinate of starting (top of the star)
        r:Float, // radius of the star (see explanation)
        fill:Int, // fill mode: 0=nothing, 1=half, 2=full
        col0:Int, // empty-border color
        fillcol0:Int, //empty-full color
        col:Int, // full-border color
        fillcol:Int, // full-fill color
        alpha:Float // alpha value, transparency 1=opaque,0.5=semi-transparent,0=invisible
        ) {
        var phi : Float = 2*Math.PI/5;
        // (p2y-p1y)(p3x-p1x)/(p3y-p1y)
        var r2 : Float = ((Math.cos(phi*1)*r)-r)*((Math.sin(phi*2)*r)-0)/(Math.cos(phi*2)*r-r);
        r2 = Math.sqrt(r2*r2+Math.pow(Math.cos(phi)*r,2));
        g.lineStyle(1,(fill==0 ? col0 : col),alpha,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
        g.beginFill((fill==2 ? fillcol : fillcol0),alpha);
        g.moveTo(x,y+r-r);
        g.lineTo(x+Math.sin(0.5*phi)*r2,y+r-Math.cos(0.5*phi)*r2);
        g.lineTo(x+Math.sin(1*phi)*r,y+r-Math.cos(1*phi)*r);
        g.lineTo(x+Math.sin(1.5*phi)*r2,y+r-Math.cos(1.5*phi)*r2);
        g.lineTo(x+Math.sin(2*phi)*r,y+r-Math.cos(2*phi)*r);
        g.lineTo(x+Math.sin(2.5*phi)*r2,y+r-Math.cos(2.5*phi)*r2);
        g.lineTo(x+Math.sin(3*phi)*r,y+r-Math.cos(3*phi)*r);
        g.lineTo(x+Math.sin(3.5*phi)*r2,y+r-Math.cos(3.5*phi)*r2);
        g.lineTo(x+Math.sin(4*phi)*r,y+r-Math.cos(4*phi)*r);
        g.lineTo(x+Math.sin(4.5*phi)*r2,y+r-Math.cos(4.5*phi)*r2);
        g.lineTo(x,y+r-r);
        g.endFill();
        if(fill!=0 && fill!=2){
            g.lineStyle(0,col,alpha,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            g.beginFill(fillcol,alpha);
            g.moveTo(x+Math.sin(2.5*phi)*r2,y+r-Math.cos(2.5*phi)*r2);
            g.lineTo(x+Math.sin(3*phi)*r,y+r-Math.cos(3*phi)*r);
            g.lineTo(x+Math.sin(3.5*phi)*r2,y+r-Math.cos(3.5*phi)*r2);
            g.lineTo(x+Math.sin(4*phi)*r,y+r-Math.cos(4*phi)*r);
            g.lineTo(x+Math.sin(4.5*phi)*r2,y+r-Math.cos(4.5*phi)*r2);
            g.lineTo(x,y+r-r);
            g.endFill();
        }
    }

    static public function drawPlayButton(
        w:Int, // width of the rectangle
        h:Int, // height of the rectangle
        r:Int  // corner radius 16
    ):Shape{
        var playBtn : Shape = new Shape();
        var g : Graphics = playBtn.graphics;
        g.lineStyle(1,0xe5e5e5);
        var colors:Array<Int> = [0xF5F5F5, 0xA0A0A0];
        var alphas:Array<Int> = [1, 1];
        var ratios:Array<Int> = [0, 255];
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(w-2, h-2, Math.PI/2, 0, 0);
        g.beginGradientFill(GradientType.LINEAR,
                            colors,
                            alphas,
                            ratios,
                            matrix,
                            SpreadMethod.PAD,
                            InterpolationMethod.LINEAR_RGB,
                            0);
        g.drawRoundRect(0,0,w,h,r,r);
        g.endFill();
        // draw a triangle
        g.lineStyle(1,0x808080);
        g.beginFill(0x0);
        g.moveTo((w-20)/2,5);
        g.lineTo((w-20)/2+20,h/2);
        g.lineTo((w-20)/2,h-5);
        g.lineTo((w-20)/2,5);
        g.endFill();
        // add the drop-shadow filter
        var shadow : DropShadowFilter = new DropShadowFilter(
        4,45,0x000000,0.8,
        4,4,
        0.65,BitmapFilterQuality.HIGH, false, false
        );
        var af : Array<Dynamic> = new Array();
        af.push(shadow);
        playBtn.filters = af;
        playBtn.alpha = 0.5;
        return playBtn;
    }*/


/*
		 * This function includes code from by Ric Ewing.
		 * @author 	Zack Jordan
		 */
		
		/*static public function drawIrregularCircle(graphics:Graphics, x:Float, y:Float, radius:Float, irregularity:Float = .2, slices:Int = -1):Void {
			if (slices < 0) {
				slices = Math.round(Math.sqrt(radius * radius * Math.PI) / 10);
				if (slices < 6) slices = 6;
			}
			
			var angle:Float = Math.random() * 2 * Math.PI; // random offset over 360 degrees (in radians)
			
			var px:Float = 0;
			var py:Float = 0;
			var rndRadius:Float = 0;
			for (var i:Int = 0; i < slices; i++) {
				rndRadius = radius * (1 + Math.random() * irregularity * 2 - irregularity / 2)
				//angle *= (1 + Math.random() * irregularity - irregularity / 2);
				px = x + Math.cos(angle) * rndRadius;
				py = y + Math.sin(angle) * rndRadius;
				
				if (i == 0) graphics.moveTo(px, py);
				graphics.lineTo(px, py);
				
				angle += 2 * Math.PI / slices;
			}
			endStyle(graphics);
		}*/

		/*static public function drawDonut(
			graphics:Graphics, 
			x:Float, 
			y:Float, 
			xRadius:Float, 
			yRadius:Float, 
			innerXRadius:Float, 
			innerYRadius:Float, 
			color:uInt = 0xFF0000, 
			fillAlpha:Float = 1 
		): Void
		{
			var segAngle	: Float
			var theta		: Float
			var angle		: Float
			var angleMid	: Float
			var segs		: Float
			var bx		: Float
			var by		: Float
			var cx		: Float
			var cy		: Float;
 
			segs = 8;
			segAngle = 45;
			theta = 0;
			angle = 0;
 
			//graphics.lineStyle( 0, 0x000000, 1 );
			graphics.beginFill( color, fillAlpha );
			graphics.moveTo( 
				x + Math.cos( 0 ) * innerXRadius,
				y + Math.sin( 0 ) * innerYRadius 
			);
 
			// line 1
			graphics.lineTo( 
				x + Math.cos( 0) * xRadius,
				y + Math.sin( 0) * yRadius 
			);
 
			// outer arc
			for ( var i:Int = 0; i < segs; i++ ) {
				angle += theta;
				angleMid = angle - ( theta / 2 );
				bx = x + Math.cos( angle ) * xRadius;
				by = y + Math.sin( angle ) * yRadius;
				cx = x + Math.cos( angleMid ) * ( xRadius / Math.cos( theta / 2 ) );
				cy = y + Math.sin( angleMid ) * ( yRadius / Math.cos( theta / 2 ) );
				graphics.curveTo( cx, cy, bx, by );
			}
 
			// line 2
			graphics.lineTo( 
				x + Math.cos( 2 * Math.PI ) * innerXRadius, 
				y + Math.sin( -2 * Math.PI ) * innerYRadius 
			);
 
			theta = -( segAngle / 180 ) * Math.PI;
			angle = -2 * Math.PI;
 
			// inner arc
			for (var j:Int = 0; j < segs; j++ ) {
				angle -= theta;
				angleMid = angle + ( theta / 2 );
				bx = x + Math.cos( angle ) * innerXRadius;
				by = y + Math.sin( angle ) * innerYRadius;
				cx = x + Math.cos( angleMid ) * ( innerXRadius / Math.cos( theta / 2 ) );
				cy = y + Math.sin( angleMid ) * ( innerYRadius / Math.cos( theta / 2 ) );
				graphics.curveTo( cx, cy, bx, by );
			}			
			endStyle(graphics);			
		}
		 
		 
		*//**
		 * Draws a wedge shape onto a Graphics3D instance.
		 * 
		 * @param 	graphics		a Graphics3D instance on which to draw
		 * @param 	x				x position of the center of this wedge
		 * @param	y				y position of the center of this wedge
		 * @param	startAngle		the angle of one straight line of this wedge
		 * @param	arc				the angle (in degrees) of the total arc of this wedge
		 * @param	xRadius			the external radius along the x axis
		 * @param	yRadius			the external radius along the y axis
		 * @param	innerXRadius	the Internal radius along the x axis
		 * @param	innerYRadius	the Internal radius along the y axis
		 * @param	color			the color of the wedge fill
		 * @param	fillAlpha		the alpha value of the wedge fill
		 * 
		 * @return					nothing
		 *//*
		static public function drawWedge( 
			graphics:Graphics, 
			x:Float, 
			y:Float, 
			startAngle:Float, 
			arc:Float, 
			xRadius:Float, 
			yRadius:Float, 
			innerXRadius:Float, 
			innerYRadius:Float, 
			color:uInt = 0xFF0000, 
			fillAlpha:Float = 1 
		): Void
		{
			var segAngle	: Float
			var theta		: Float
			var angle		: Float
			var angleMid	: Float
			var segs		: Float
			var bx		: Float
			var by		: Float
			var cx		: Float
			var cy		: Float;
 
			segs = Math.ceil( Math.abs( arc ) / 45 );
			segAngle = arc / segs;
			theta = -( segAngle / 180 ) * Math.PI;
			angle = -( startAngle / 180 ) * Math.PI;
 
			//graphics.lineStyle( 0, 0x000000, 1 );
			graphics.beginFill( color, fillAlpha );
			graphics.moveTo( 
				x + Math.cos( startAngle / 180 * Math.PI ) * innerXRadius,
				y + Math.sin( -startAngle/180 * Math.PI ) * innerYRadius 
			);
 
			// line 1
			graphics.lineTo( 
				x + Math.cos( startAngle / 180 * Math.PI ) * xRadius,
				y + Math.sin( -startAngle / 180 * Math.PI ) * yRadius 
			);
 
			// outer arc
			for ( var i:Int = 0; i < segs; i++ ) {
				angle += theta;
				angleMid = angle - ( theta / 2 );
				bx = x + Math.cos( angle ) * xRadius;
				by = y + Math.sin( angle ) * yRadius;
				cx = x + Math.cos( angleMid ) * ( xRadius / Math.cos( theta / 2 ) );
				cy = y + Math.sin( angleMid ) * ( yRadius / Math.cos( theta / 2 ) );
				graphics.curveTo( cx, cy, bx, by );
			}
 
			// line 2
			graphics.lineTo( 
				x + Math.cos( ( startAngle + arc ) / 180 * Math.PI ) * innerXRadius, 
				y + Math.sin( -( startAngle + arc ) / 180 * Math.PI ) * innerYRadius 
			);
 
			theta = -( segAngle / 180 ) * Math.PI;
			angle = -( ( startAngle + arc ) / 180 ) * Math.PI;
 
			// inner arc
			for (var j:Int = 0; j < segs; j++ ) {
				angle -= theta;
				angleMid = angle + ( theta / 2 );
				bx = x + Math.cos( angle ) * innerXRadius;
				by = y + Math.sin( angle ) * innerYRadius;
				cx = x + Math.cos( angleMid ) * ( innerXRadius / Math.cos( theta / 2 ) );
				cy = y + Math.sin( angleMid ) * ( innerYRadius / Math.cos( theta / 2 ) );
				graphics.curveTo( cx, cy, bx, by );
			}			
			endStyle(graphics);			
		}
		
		public static inline function drawTriangle(graphics:Graphics, x:Float, y:Float, size:Float, invert:Boolean = false):Void {
			if (invert) {
				graphics.moveTo(x, y - size / 2);
				graphics.lineTo(x + size / 2, y + size / 2);
				graphics.lineTo(x - size / 2, y + size / 2);
			} else {
				graphics.moveTo(x - size / 2, y - size / 2);
				graphics.lineTo(x + size / 2, y - size / 2);
				graphics.lineTo(x, y + size / 2);	
			}
		}
		
		public static inline function drawArrow(graphics:Graphics, size:Float):Void {
			//graphics.drawRect(-size / 4, 0, size/2, size / 2);
			drawTriangle(graphics, 0, size, size);
		}*/
}