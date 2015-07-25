package com.nachofries.framework.dialog;
import com.nachofries.framework.lifecycle.LifecycleSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class DialogContentsWrapper extends DialogContents {
    private var dialogContents:DialogContents = null;
    private var dialogContentsParent:DialogContents = null;

	public function new(?dialogContents:DialogContents, ?options:Map<String, Dynamic>) {
		super();
        dialogContentsParent = this;
        if(dialogContents != null) {
            setDialogContents(dialogContents);
        }
	}

    public function setDialogContents(dialogContents:DialogContents):DialogContents {
        if(this.dialogContents != null) {
            dialogContentsParent.removeSprite(this.dialogContents);
        }
        this.dialogContents = dialogContents;
        dialogContents.setDialog(dialog);
        dialogContentsParent.addAndWatchSprite(dialogContents);
        return dialogContents;
    }

    override public function setDialog(dialog:Dialog):Void {
        super.setDialog(dialog);
        if(dialogContents != null) {
            dialogContents.setDialog(dialog);
        }
    }

    override public function populate(params:Dynamic):Void {
        super.populate(params);
        if(dialogContents != null) {
            dialogContents.populate(params);
        }
    }
}