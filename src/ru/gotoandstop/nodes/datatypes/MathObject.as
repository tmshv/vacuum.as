/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 6/2/12
 * Time: 3:13 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeObject;

public class MathObject extends NodeObject{
    public function MathObject() {
        on("first", recalc);
        on("second", recalc);
        on("operation", recalc);
    }

    private function recalc(event:Event):void{
        var first:Number = get("first");
        var second:Number = get("second");
        var operation:String = get("operation");
        var product:Number;
        if(operation == "+") product = first + second;
        else if(operation == "-") product = first - second;
        else if(operation == "/") product = first / second;
        else if(operation == "*") product = first * second;
        else product = first;

        set("product", product);
    }
}
}
