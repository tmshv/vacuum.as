/**
 *
 * User: tmshv
 * Date: 5/12/12
 * Time: 8:01 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.core.NodeObject;

public class CompareObject extends NodeObject{
    private static function operationIsValid(oper:String):Boolean{
        return ['<', '>', '>=', '<=', '=', '=='].indexOf(oper) >= 0;
//        return oper=="<" || oper==">" || oper=="=" || oper=="<=" || oper==">=" || oper=="==";
    }

    public function CompareObject() {
        super.addEventListener(Event.CHANGE, handleChange);
    }

    private function handleChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var key:String = change.key;
            if (key == "operand1" || key == "operand2" || key == "operation") {
                update();
            }
        }
    }

    override public function update():void {
        var o1:Number = get("operand1");
        var o2:Number = get("operand2");
        var oper:String = get("operation");

        if(o1!=NaN && o2!=NaN && operationIsValid(oper)){
            var result:Boolean;
            if (oper == "<")result = o1 < o2;
            else if (oper == ">") result = o1 > o2;
            else if (oper == "<=") result = o1 <= o2;
            else if (oper == ">=") result = o1 >= o2;
            else if (oper == "=" || oper == "==") result = o1 == o2;
            else result = false;

            set("result", result);
        }

        super.update();
    }

    override public function dispose():void {
        super.removeEventListener(Event.CHANGE, handleChange);
        super.dispose();
    }
}
}
