package com.nachofries.framework.behavior;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.DisplayableFields;
import com.nachofries.framework.util.DisplayableField;

/**
 * ...
 * @author Michael R. Bernstein
 */

class StayBehavior extends Behavior {
    private var field:DisplayableField;
    private var originalValue:Float;

    public static function createFromJson(json:Dynamic):StayBehavior {
        return StayBehavior.create(Type.createEnum(DisplayableField, json.field));
    }

    public static inline function create(?field:DisplayableField):StayBehavior {
        var item:StayBehavior = Pooling.get(ClassInfo.getClassName());
        if(item == null) {
            item = new StayBehavior();
        }
        item.init(field);
        return item;
    }

    public function new() {
        super();
    }
    private function init(?field:DisplayableField) {
        if(field == null) {
            field = DisplayableField.X_CENTER;
        }
        this.field = field;
    }

    override public function setTarget(target:Displayable):Void {
        super.setTarget(target);
        originalValue = DisplayableFields.getValue(target, field);
    }

    override public function update():Void {
        super.update();
        DisplayableFields.setValue(target, field, originalValue);
    }

    override public function destroy():Void {
        super.destroy();
        Pooling.recycle(this);
    }
}