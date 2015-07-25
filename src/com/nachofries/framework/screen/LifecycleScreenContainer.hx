package com.nachofries.framework.screen;
import com.nachofries.framework.lifecycle.LifecycleSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */
class LifecycleScreenContainer extends LifecycleScreen {
    private var screenContainer:LifecycleSprite;
    private var screens:Map<String, LifecycleScreen>;
    private var screen:LifecycleScreen;

    public function new(name:String):Void {
        super(name);
        screens = new Map<String, LifecycleScreen>();
        screenContainer = new LifecycleSprite();
        addChild(screenContainer);
    }

    public function addStateScreen(state:String, screen:LifecycleScreen):Void {
        screens.set(state, screen);
    }
    public function canHandleState(state:String):Bool {
        return screens.exists(state);
    }
    public function setState(state:String):Void {
        if(screen != null) {
            screenContainer.removeChild(screen);
        }
        screen = screens.get(state);
        screenContainer.addChild(screen);

        #if (debug && windows)
        pgr.dconsole.DC.registerObject(screen, "screen");
        #end
    }

    override public function reset():Void {
        super.reset();
        if(screen != null) {
            screen.reset();
        }
    }

    override public function start():Void {
        super.start();
        if(screen != null) {
            screen.start();
        }
    }

    override public function stop():Void {
        super.stop();
        if(screen != null) {
            screen.stop();
        }
    }

    override public function update():Void {
        super.update();
        if(screen != null) {
            screen.update();
        }
    }

    override public function updateScreen():Void {
        super.updateScreen();
        if(screen != null) {
            screen.updateScreen();
        }
    }

    override public function populate(?params:Dynamic):Void {
        super.populate(params);
        if(screen != null) {
            screen.populate(params);
        }
    }
}