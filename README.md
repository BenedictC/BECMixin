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


    @interface FooMixin : NSObject
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

    //No need to define a FooBarMixin class.
    @protocol FooBarMixin <FooMixin, BarMixin>
    @end


    
Method implementation precedence
--
TODO:
