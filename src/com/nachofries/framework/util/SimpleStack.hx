package com.nachofries.framework.util;

class SimpleStack<T> {

    public var head : SimpleCell<T>;

    /**
		Creates a new empty GenericStack.
	**/
    public function new() {
    }

    /**
		Pushes element `item` onto the stack.
	**/
    public inline function add( item : T ) {
        head = new SimpleCell<T>(item,head);
    }
    public inline function clear() {
        head = null;
    }

    /**
		Returns the topmost stack element without removing it.

		If the stack is empty, null is returned.
	**/
    public inline function first() : Null<T> {
        return if( head == null ) null else head.object;
    }

    /**
		Returns the topmost stack element and removes it.

		If the stack is empty, null is returned.
	**/
    public inline function pop() : Null<T> {
        var k = head;
        if( k== null )
            return null;
        else {
            head = k.next;
            return k.object;
        }
    }

    /**
		Tells if the stack is empty.
	**/
    public inline function isEmpty() : Bool {
        return (head == null);
    }

    /**
		Removes the first element which is equal to `v` according to the `==`
		operator.

		This method traverses the stack until it finds a matching element and
		unlinks it, returning true.

		If no matching element is found, false is returned.
	**/
    public function remove( v : T ) : Bool {
        var prev = null;
        var l = head;
        while( l != null ) {
            if( l.object == v ) {
                if( prev == null )
                    head = l.next;
                else
                    prev.next = l.next;
                break;
            }
            prev = l;
            l = l.next;
        }
        return (l != null);
    }

    public function exists(item:T):Bool {
        for (object in this) {
            if(item == object) {
                return true;
            }
        }
        return false;
    }

    #if cpp

    /**
		Returns an iterator over the elements of `this` GenericStack.
	**/
    public function iterator() : Iterator<T> {
        return new GenericStackIterator<T>(head);
    }

    #else

    /**
		Returns an iterator over the elements of `this` GenericStack.
	**/
    public function iterator() : Iterator<T> {
        var l = head;
        return {
            hasNext : function() {
                return l != null;
            },
            next : function() {
                var k = l;
                l = k.next;
                return k.object;
            }
        };
    }
    #end

    /**
		Returns a String representation of `this` GenericStack.
	**/
    public function toString() {
        var a = new Array();
        var l = head;
        while( l != null ) {
            a.push(l.object);
            l = l.next;
        }
        return "{"+a.join(",")+"}";
    }

}

class SimpleCell<T> {
    public var object : T;
    public var next : SimpleCell<T>;
    public function new(object,next) { this.object = object; this.next = next; }
}

#if cpp
private class GenericStackIterator<T> extends cpp.FastIterator<T> {
    public var current : SimpleCell<T>;
    override public function hasNext():Bool { return current!=null; }
    override public function next():T { var result = current.object; current = current.next; return result; }

    public function new(head) { current = head; }
}

#end
