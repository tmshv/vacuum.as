/**
 * Created with IntelliJ IDEA.
 * User: Roman
 * Date: 18.03.13
 * Time: 14:08
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import flash.utils.ByteArray;

import ru.gotoandstop.ISerializable;

public class NodeDefinition implements ISerializable {
    /**
     * Создает экземпляр <code>NodeDefinition</code>
     * @param def прототипный объект дефинишена
     * @return экземпляр <code>NodeDefinition</code>, построенный на основе def
     */
    public static function create(def:Object):NodeDefinition {
        if (!def.type || !def.object || !def.node) {
            throw new ArgumentError('node argument must contain String type, Class object and Class node fields');
        }

        var nd:NodeDefinition = new NodeDefinition();
        nd._type = def.type;
        nd._nodeDefinition = def.object;
        nd._vacuumNodeDefinition = def.node;
        for each(var p:Object in def.params) {
            nd.params.push(p);
        }
        nd._extras = def.extras;
        return nd;
    }

    private var _type:String;
    /**
     * Тип нода. Строковое значение
     */
    public function get type():String {
        return _type;
    }

    private var _nodeDefinition:String;
    /**
     * Название дефинишена нода-объекта
     */
    public function get nodeDefinition():String {
        return _nodeDefinition;
    }

    private var _vacuumNodeDefinition:String;
    /**
     * Название дефинишена визуального нода
     */
    public function get vacuumNodeDefinition():String {
        return _vacuumNodeDefinition;
    }

    private var _params:Vector.<Object>;
    /**
     * Список параметров нода
     */
    public function get params():Vector.<Object> {
        return _params;
    }

    private var _extras:Object;
    /**
     * Словарь дополнительных параметров для вакуумного нода
     */
    public function get extras():Object {
        return _params;
    }

    public function NodeDefinition() {
        _params = new Vector.<Object>();
    }

    /**
     * Создает копию экземпляра <code>NodeDefinition</code>
     * @return экземпляр <code>NodeDefinition</code>, содержащий параметры текущего объекта
     */
    public function clone():NodeDefinition {
        return NodeDefinition.create(serialize());
    }

    public function serialize():Object {
        var params_clone:Array = cloneVector(params);
        var extras_clone:Object = cloneObject(extras);
        return {
            "type":type,
            "object":nodeDefinition,
            "node":vacuumNodeDefinition,
            "params":params_clone,
            "extras":extras_clone
        };
    }

    private function cloneVector(vector:Vector.<Object>):Array {
        var clone:Array = [];
        for each(var p:Object in vector) {
            var ba:ByteArray = new ByteArray();
            ba.writeObject(p);
            ba.position = 0;
            clone.push(ba.readObject());
        }
        return clone;
    }

    private function cloneObject(object:Object):Object {
        var ba:ByteArray = new ByteArray();
        ba.writeObject(object);
        ba.position = 0;
        return ba.readObject();
    }
}
}
