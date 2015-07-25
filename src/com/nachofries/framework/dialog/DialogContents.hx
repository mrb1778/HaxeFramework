package com.nachofries.framework.dialog;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;

/**
 * ...
 * @author Michael R. Bernstein
 */

class DialogContents extends LifecycleSpriteWatcher {
    var dialog:Dialog;
    public var onCloseHandler:Void->Void;

    public function setDialog(dialog:Dialog):Void {
        this.dialog = dialog;
    }

    public function onClose(?_:Dynamic):Void {
        if(onCloseHandler != null) {
            onCloseHandler();
        } else {
            dialog.close();
        }
    }
    public function populate(params:Dynamic):Void {
        if(params != null) {
            if(params.onClose != null) {
                onCloseHandler = params.onClose;
            }
        }
    }

    public function getDialogOptions():Map<String, Dynamic> {
        return null;
    }
}