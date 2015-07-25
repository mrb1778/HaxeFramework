package com.nachofries.framework.dialog;

import com.nachofries.framework.util.Delay;
import com.nachofries.framework.dialog.Dialog;
import com.nachofries.framework.screen.LifecycleScreen;
import com.nachofries.framework.lifecycle.LifeCycleManager;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;

/**
 * ...
 * @author Michael R. Bernstein
 */
class Dialog extends LifecycleSpriteWatcher {
	public static inline var EVENT_CLOSE:String = "dialog.close";

	public static inline var DIALOG_PAUSE:String = "pause";
	public static inline var DIALOG_WIN:String = "win";
	public static inline var DIALOG_FAIL:String = "fail";
	public static inline var DIALOG_CONTINUE:String = "continue";
	public static inline var DIALOG_MESSAGE:String = "message";
	public static inline var DIALOG_IMAGE:String = "image";
	public static inline var DIALOG_STORE:String = "store";
	public static inline var DIALOG_HELP:String = "help";
	public static inline var DIALOG_INTRO:String = "intro";

    //todo: make setting
    private static inline var DEFAULT_AUTO_REMOVE:Int = 50;

    private var autoRemoveDelay:Delay = null;
    private var autoRemove:Bool = false;
    private var autoRemoveTime:Int;

    private var dialogContents:DialogContents = null;

	private static var dialogs:Map<String, Dialog>;
	var handler:LifecycleScreen;

	public static function registerDialog(name:String, dialog:Dialog):Void {
		if(dialogs == null) {
            dialogs = new Map();
		}
        dialogs.set(name, dialog);
    }

	public static function hasDialog(name:String):Bool {
        return dialogs.exists(name);
    }

	public static function getDialog(name:String, ?params:Dynamic):Dialog {
		if(dialogs != null) {
			var dialog:Dialog = dialogs.get(name);
			if(dialog != null) {
				dialog.reset();
				dialog.populate(params);

				return dialog;
			}
		}
		return null;
	}

    public function new(?dialogContents:DialogContents) {
        super();
        if(dialogContents != null) {
            setDialogContents(dialogContents);
        }
    }

    public function setDialogContents(dialogContents:DialogContents):DialogContents {
        this.dialogContents = dialogContents;
        dialogContents.setDialog(this);
        addAndWatchSprite(dialogContents);
        return dialogContents;
    }

	function populate(params:Dynamic):Void {
        this.handler = params.handler;
        if(params.autoRemove == true || params.autoRemoveDelay != null) {
            setAutoRemoveTime(params.autoRemoveDelay != null ? params.autoRemoveDelay : DEFAULT_AUTO_REMOVE);
        } else {
            autoRemoveDelay = null;
        }

        if(dialogContents != null) {
            dialogContents.populate(params);
        }
    }

	function onClose(?_):Bool {
		close();
        return true;
	}
    public function close():Void {
		handler.removeDialog();
	}

    override public function start():Void {
        super.start();
        if(autoRemove && autoRemoveDelay != null) {
            setAutoRemoveTime(autoRemoveTime);
        }
        if(autoRemoveDelay != null) {
            autoRemoveDelay.start();
        }
    }

    public function setAutoRemove(autoRemove:Bool=true, autoRemoveTime:Int=DEFAULT_AUTO_REMOVE):Dialog {
        this.autoRemove = autoRemove;
        this.autoRemoveTime = autoRemoveTime;
        return this;
    }

    private function setAutoRemoveTime(time:Int):Dialog {
        autoRemoveDelay = Delay.create(time, onClose);
        autoRemoveDelay.start();
        return this;
    }

    override public function reset():Void {
        super.reset();
        if(dialogContents != null) {
            dialogContents.reset();
        }
        if(autoRemoveDelay != null) {
            autoRemoveDelay.reset();
        }
    }
    override public function update():Void {
        super.update();
        if(autoRemoveDelay != null) {
            autoRemoveDelay.update();
        }
    }

	function onNext(_):Void { LifeCycleManager.goNext(); }
	function onBack(_):Void { LifeCycleManager.goBack(); }
}