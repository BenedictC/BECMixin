BECMixin
========

BECMixin adds mixins to Objective-C.

This project was created as a proof of concept and should not be used in production code.



Usage
--
A mixin is a combination of a protocol and a class. The protocol must conform to the BECMixin protocol. The optional methods in the protocol must be implemented in a class with the same name as the protocol. Required methods must be implemented by the class that is conforming to the mix in protocol.

EG:

    @protocol FooMixin <BECMixin>
    -(void)foo;
    @end


    @interface FooMixin : NSObject //If you want to make life really complicated you can inherit from a different class.
    @end
    
    
    @implementation FooMixin
    -(void)foo
    {
        //Do foo
    }
    @end
    
    
    //Instance of AnObject will respond to foo.
    @interface AnObject : NSObject <FooMixin>
    @end
    
    @implmentation
    @end
    
   
   
Mixin inheritance
--
Just like normal protocols mixins can extended. Methods can be overriden when extending a mixin. EG:

    @protocol MegaFooMixin <FooMixin>
    -(void)megaFoo;
    @end


    @interface MegaFooMixin : NSObject
    @end
    
    
    @implementation MegaFooMixin
    -(void)megaFoo
    {
        //Do megaFoo
    }
    
    -(void)foo
    {
        //Different foo than FooMixin::foo
    }
    @end


If a mixin defines no methods and only inherits from other mixins then a class does not need to be defined. EG:

    @protocol FooBarMixin <FooMixin, BarMixin> //No need to define a FooBarMixin class.
    @end

    
Method implementation precedence
--
Method implementation precedence is complicated. The order is determined by the order in which the protocols are listed and their inheritance. In the MegaFooMixin example the foo method of MegaFooMixin had higher precedence than the foo method of FooMixin therefore when the MegaFooMixin is applied to an object the foo implementation will be that of MegaFooMixins. However this can be overridden if the object explicitly conformed to the FooMixin before the MegaFooMixin. EG:


@interface AnObject <MegaFooMixin> //Will use foo implementation from MegaFooMixin
@end


@interface AnObject <FooMixin, MegaFooMixin> //Will use foo implementation from FooMixin
@end

Mixins declared on a class continuation (a.k.a. anonymous category) are applied before those declared on an interface. Mixins declared on categories are ignored.

This ordering is due to the order that the protocols are runtime returns information. Clang nor the runtime documentation mention the ordering of these methods so it is not safe to assume that they will be consistent between releases.
