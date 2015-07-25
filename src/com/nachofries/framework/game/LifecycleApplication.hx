/**
 * ...
 * @author Michael R. Bernstein
 */
package com.nachofries.framework.game;

import com.nachofries.framework.util.Sounds;
import com.nachofries.framework.util.SavedSettings;
import com.nachofries.framework.util.Settings;
import com.nachofries.framework.screen.LifecycleScreenContainer;
import com.nachofries.framework.screen.LifecycleScreen;
import com.nachofries.framework.screen.ImageBehaviorScreen;
import com.nachofries.framework.lifecycle.LifeCycleController;
import com.nachofries.framework.spritesheet.SpriteSheetManager;
import com.nachofries.framework.lifecycle.LifeCycleManager;
import com.nachofries.framework.util.NumberUtils;
import com.nachofries.framework.util.Application;

import openfl.display.StageQuality;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.Lib;

class LifecycleApplication extends Sprite implements LifeCycleController {
    private static var STATE_DEFAULT:String = GameState.TITLE;
    private var previousState:String;
    private var currentState:String;
    private var currentParams:Dynamic;
    private var currentScreen:LifecycleScreen;
    private var screens:Map<String, LifecycleScreen>;
    private var nextMap:Map<String, String>;
    private var backMap:Map<String, String>;
    private var screenHandlers:Array<LifecycleScreenContainer>;

	public function new():Void {
		super();
        screens = new Map<String, LifecycleScreen>();
        backMap = new Map<String, String>();
        nextMap = new Map<String, String>();
        screenHandlers = [];
        SavedSettings.initialize();
        #if (debug && windows)
            Settings.loadSettings();
        #else
            var settingsJson:SettingsConfig = CompileTime.parseJsonFile("assets/settings.json");
            Settings.populateSettings(settingsJson);
        #end

        /*Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;*/
        Lib.current.stage.quality = StageQuality.BEST;
        Application.initSizes();
        SpriteSheetManager.loadSpriteSheet();
        LifeCycleManager.initialize(this);
        Sounds.initialize();
        currentState = GameState.SPLASH;
        setScreen(createSplashScreen());
        #if (android || windows)
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
        #end
        #if windows
        Lib.current.stage.addEventListener(Event.RESIZE, onReSize);
        #end
        Lib.current.addEventListener(Event.ENTER_FRAME, updateFrame);

        #if (debug && windows)
        pgr.dconsole.DC.registerObject(this, "mainObj");
        pgr.dconsole.DC.registerClass(Application, "app");
        pgr.dconsole.DC.registerClass(SavedSettings, "ss");
        #end
	}
	private function createSplashScreen():LifecycleScreen {
        return new ImageBehaviorScreen(GameState.SPLASH);
    }
	function update():Void { currentScreen.update(); }
	function updateFrame(_):Void { update(); }
	public function changeState(newState:String, ?params:Dynamic):Void {
		if (currentScreen != null) {
            currentScreen.stop();
			removeChild(currentScreen);
		}
        setScreen(getScreenForState(newState, params), params);
        previousState = currentState;
        currentState = newState;
        currentParams = params;
	}
    private function setScreen(screen:LifecycleScreen, ?params:Dynamic):Void {
        currentScreen = screen;
        currentScreen.reset();
        currentScreen.populate(params);
        addChild(currentScreen);
        currentScreen.start();

        #if (debug && windows)
        pgr.dconsole.DC.registerObject(screen, "screen");
        #end
    }

    public function addStateScreen(state:String, screen:LifecycleScreen):Void {
        screens.set(state, screen);
    }
    public function canHandleState(state:String):Bool {
        return screens.exists(state);
    }
    private function getScreenForState(newState:String, params:Dynamic):LifecycleScreen {
        if(screens.exists(newState)) {
            return screens.get(newState);
        }
        return getUnhandledScreenForState(newState, params);
    }

    private function getUnhandledScreenForState(newState:String, params:Dynamic):LifecycleScreen {
        for(screenHandler in screenHandlers) {
            if(screenHandler.canHandleState(newState)) {
                screenHandler.setState(newState);
                return screenHandler;
            }
        }
        return null;
    }


    public function restart(?params:Dynamic):Void {
        changeState(currentState, params != null ? params : currentParams);
    }

    public function goBack(?params:Dynamic):Void {
        if(backMap.exists(currentState)) {
            changeState(backMap.get(currentState), params);
        } else {
            changeState(previousState, params);
            previousState = STATE_DEFAULT;
        }
    }
    public function goNext(?params:Dynamic):Void {
        if(nextMap.exists(currentState)) {
            changeState(nextMap.get(currentState), params);
        }
    }

	function handleKey(event:KeyboardEvent):Void {
        if (event.keyCode == NumberUtils.GESTURE_BACK || event.keyCode == NumberUtils.KEYCODE_BACK) {
            goBack();
			/*if (!goBack()) {
                #if not html5
				Lib.close();
				#end
			}*/
		}
        //Reflect.setField(event, "nmeIsCancelled", true); //event.stopPropagation();
	}
    function onReSize(_):Void {
        Application.initSizes();
    }
}