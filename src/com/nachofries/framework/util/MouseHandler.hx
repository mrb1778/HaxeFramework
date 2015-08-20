package com.nachofries.framework.util;

import openfl.geom.Point;
import openfl.events.MouseEvent;
import com.nachofries.framework.screen.LifecycleScreen;
class MouseHandler {
    private static inline var MIN_MOUSE_DRAG:Float = 5;
    
    private var screen:LifecycleScreen;
    private var mouseCheck:Void->Bool;
    private var mouseDownListener:Point->Void;
    private var mouseDragListener:Point->Point->Void;
    private var mouseDragStopListener:Point->Point->Void;
    private var mouseUpListener:Point->Point->Void;
    private var mouseMoveListener:Point->Point->Void;
    private var mouseClickListener:Point->Void;

    private var mouseDownPoint:Point;

    public function new(screen:LifecycleScreen) {
        this.screen = screen;
    }
    public inline function setMouseDragListener(mouseDragListener:Point->Point->Void):MouseHandler {
        this.mouseDragListener = mouseDragListener;
        return this;
    }
    public inline function setMouseDragStopListener(mouseDragStopListener:Point->Point->Void):MouseHandler {
        this.mouseDragStopListener = mouseDragStopListener;
        return this;
    }
    public inline function setMouseUpListener(mouseUpListener:Point->Point->Void):MouseHandler {
        this.mouseUpListener = mouseUpListener;
        return this;
    }
    public inline function setMouseDownListener(mouseDownListener:Point->Void):MouseHandler {
        this.mouseDownListener = mouseDownListener;
        return this;
    }
    public inline function setMouseCheck(mouseCheck:Void->Bool):MouseHandler {
        this.mouseCheck = mouseCheck;
        return this;
    }
    public inline function setMouseMoveListener(mouseMoveListener:Point->Point->Void):MouseHandler {
        this.mouseMoveListener = mouseMoveListener;
        return this;
    }
    public inline function setMouseClickListener(mouseClickListener:Point->Void):MouseHandler {
        this.mouseClickListener = mouseClickListener;
        return this;
    }
    public function start():Void {
        screen.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        screen.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        screen.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        screen.addEventListener(MouseEvent.CLICK, onMouseClick);
    }
    public function stop():Void {
        screen.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        screen.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        screen.removeEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseDown(event:MouseEvent):Void {
        if(checkMouse()) {
            mouseDownPoint = translatePoint(event);
            if(mouseDownListener != null) {
                mouseDownListener(mouseDownPoint);
            }
        }
    }
    private function onMouseMove(event:MouseEvent):Void {
        if(checkMouse() && (mouseMoveListener != null || mouseDragListener != null)) {
            var endPoint:Point = translatePoint(event);

            if(mouseMoveListener != null) {
                mouseMoveListener(mouseDownPoint, endPoint);
            }
            if(mouseDragListener != null && isDrag(endPoint)) {
                mouseDragListener(mouseDownPoint, endPoint);
            }
        }
    }
    private function onMouseUp(event:MouseEvent):Void {
        if(checkMouse() && (mouseUpListener != null || mouseDragStopListener != null)) {
            var endPoint:Point = translatePoint(event);
            if(mouseUpListener != null) {
                mouseUpListener(mouseDownPoint, endPoint);
            }
            if(mouseDragStopListener != null && isDrag(endPoint)) {
                mouseDragStopListener(mouseDownPoint, endPoint);
            }
        }
        mouseDownPoint = null;
    }

    private function onMouseClick(event:MouseEvent):Point {
        if(checkMouse() && mouseClickListener != null) {
            mouseClickListener(translatePoint(event));
        }
        return null;
    }

    private inline function translatePoint(event:MouseEvent):Point {
        return screen.globalToLocal(new Point(event.stageX, event.stageY));
    }

    private inline function checkMouse():Bool {
        return mouseCheck == null || mouseCheck();
    }

    private inline function isDrag(endPoint:Point):Bool {
        var xDistance = Math.abs(endPoint.x - mouseDownPoint.x);
        var yDistance = Math.abs(endPoint.y - mouseDownPoint.y);
        return Math.max(xDistance, yDistance) > MIN_MOUSE_DRAG;
    }
}