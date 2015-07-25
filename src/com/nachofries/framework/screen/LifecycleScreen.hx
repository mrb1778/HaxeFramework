package com.nachofries.framework.screen;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.SpriteDecorator;
import com.nachofries.framework.util.Settings;
import com.nachofries.framework.dialog.Dialog;
import com.nachofries.framework.lifecycle.LifecycleEvent;
import com.nachofries.framework.util.Events;
import com.nachofries.framework.util.Sounds;
import com.nachofries.framework.util.DialogHandler;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import com.nachofries.framework.lifecycle.LifeCycleManager;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;

/**
 * ...
 * @author Michael R. Bernstein
 */
class LifecycleScreen extends LifecycleSpriteWatcher implements DialogHandler {
    //todo: auto build graphics and background from name, but name has to be set first, name is from state, set in constructor?
    private var currentDialog:LifecycleSprite;
    private var previousDialog:LifecycleSprite;

    public function new(name:String) {
        super();
        this.name = name;

        Drawing.fillScreen(this, Settings.getSetting(name + ".background", "0x000000"));
        var backgrounds:Array<String> = Settings.getSetting(name + ".backgrounds", []);
        for (background in backgrounds) {
            Drawing.fillScreen(this, background);
        }
        SpriteDecorator.decorate(this, Settings.getSetting(name + ".graphics", []));
    }

    public function populate(?params:Dynamic):Void {}

    override public function update():Void {
        super.update();
        if(hasDialog()) {
            currentDialog.update();
        } else {
            updateScreen();
        }
    }
    private function updateScreen():Void {}

    public function showDialog(dialog:LifecycleSprite):Void {
        previousDialog = currentDialog;
        removeDialog();
        if(dialog != null) {
            Events.fire(LifecycleEvent.ON_DIALOG_SHOW, {parent: this, dialog: dialog});
            currentDialog = dialog;
            currentDialog.start();
            addAndWatchSprite(currentDialog);
            Sounds.pauseBackgroundMusic();
        }
    }
    public function removeDialog():Void {
        if (hasDialog()) {
            Events.fire(LifecycleEvent.ON_DIALOG_HIDE, {parent: this, dialog: currentDialog});
            removeSprite(currentDialog);
            currentDialog.stop();
            var currentDialogTemp:LifecycleSprite = currentDialog;
            currentDialog = null;
            Sounds.resumeBackgroundMusic();

            if(previousDialog != null && currentDialogTemp != previousDialog) {
                showDialog(previousDialog);
            }
        }
    }
    public function hasDialog():Bool return currentDialog != null;

    private function showDialogListener(params:Dynamic):Bool {
        var dialog:LifecycleSprite = params.dialog;
        if(dialog != null) {
            showDialog(dialog);
        } else {
            params.handler = this;
            showDialog(Dialog.getDialog(params.dialogName, params));
        }
        return true;
    }

    override public function start():Void {
        super.start();
        Events.on(LifecycleEvent.SHOW_DIALOG, showDialogListener);
    }

    override public function stop():Void {
        super.stop();
        removeDialog();
        previousDialog = null;
        currentDialog = null;
        Events.stopListening(LifecycleEvent.SHOW_DIALOG, showDialogListener);
    }

    public function quit():Void {
        LifeCycleManager.goBack();
    }
    public function restart():Void {
        removeDialog();
        LifeCycleManager.restart();
    }
}