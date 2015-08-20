package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */
@final
class Delay implements Updateable {
    private static inline var DEFAULT_TIME:Int = 100;
    private var started:Bool = false;
    private var time:Int;
    private var timeLeft:Int;
    private var onComplete:Dynamic->Bool;

    public static inline function create(time:Int=DEFAULT_TIME, onComplete:Dynamic->Bool):Delay {
        var delay:Delay = Pooling.get(ClassInfo.getClassName());

        if(delay == null) {
            delay = new Delay();
        }
        delay.init(time, onComplete);
        return delay;
    }

    private function new() {}

    public function init(time:Int=DEFAULT_TIME, onComplete:Dynamic->Bool):Void {
        this.time = time;
        timeLeft = time;
        this.onComplete = onComplete;
        started = false;

    }

    public function start():Delay { started = true; return this; }

    public function update():Void {
        if(started && timeLeft-- == 0) {
            onComplete(this);
            destroy();
        }
    }

    public function reset():Void { timeLeft = time; }
    public function destroy():Void {
        Pooling.recycle(this);
    }
}