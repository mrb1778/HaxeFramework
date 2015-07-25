package com.nachofries.framework.behavior;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.DisplayableFields;
import com.nachofries.framework.util.DisplayableField;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ChangeBehavior extends Behavior {
    private var field:DisplayableField;
    private var delta:Float;
    public static function createFromJson(json:Dynamic):ChangeBehavior {
        return new ChangeBehavior(Type.createEnum(DisplayableField, json.field), json.delta); //todo: scale??
    }

    public function new(?field:DisplayableField, delta:Float=.05) {
        super();
        if(field == null) {
            field = DisplayableField.ROTATION;
        }
        this.field = field;
        this.delta = delta;
	}

    override public function update():Void {
        super.update();
        DisplayableFields.moveValue(target, field, delta);
    }
}