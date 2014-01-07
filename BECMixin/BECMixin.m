//
//  BECMixin.m
//  BECMixin
//
//  Created by Benedict Cohen on 17/12/2013.
//  Copyright (c) 2013 Benedict Cohen. All rights reserved.
//

#import "BECMixin.h"
#import <objc/runtime.h>
#import <objc/Protocol.h>



@interface BECMixin : NSObject
@end



@implementation BECMixin

+(void)load
{
    [self addMixins];
    
    //Register for further code loading by observing NSBundleDidLoadNotification. (We don't need to unobserve.)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadCode:) name:NSBundleDidLoadNotification object:nil];
}



+(void)didLoadCode:(NSNotification *)notification
{
    //We have walk all classes becasue the new code may apply a mixin to a class that is already loaded.
    [self addMixins];
}



#pragma mark - mixin adding
+(void)addMixins
{
    NSMutableSet *protocolCache = [NSMutableSet new];
    [self enumerateAllClassesUsingBlock:^(__unsafe_unretained Class class) {
        NSArray *mixinProtocols = [self mixinProtocolsConformedToByClass:class protocolCache:protocolCache];

        for (Protocol *mixinProtocol in mixinProtocols) {
            [self addMethodsInMixinProtocol:mixinProtocol toClass:class];
        }
    }];
}



#pragma mark - mixin fetching
+(NSArray *)mixinProtocolsConformedToByClass:(Class)class protocolCache:(NSMutableSet *)cache
{
    NSMutableArray *applicableMixinProtocols = [NSMutableArray new];

    unsigned int classProtocolCount;
    __unsafe_unretained Protocol **classProtocols = class_copyProtocolList(class, &classProtocolCount);

    for (int i = 0; i < classProtocolCount; i++) {
        Protocol *rootProtocol = classProtocols[i];
        [applicableMixinProtocols addObjectsFromArray:[self mixinProtocolsConformedToByProtocol:rootProtocol protocolCache:(NSMutableSet *)cache]];
    }
    free(classProtocols);
//    NSLog(@"%s", class_getName(class));
    return applicableMixinProtocols;
}



+(NSArray *)mixinProtocolsConformedToByProtocol:(Protocol *)protocol protocolCache:(NSMutableSet *)cache
{
    if ([cache containsObject:protocol]) return [NSArray array];

    NSMutableArray *conformantProtocols = [NSMutableArray array];

    //Recursively check parents to see if they're mixins. This results in a depth first search.
    unsigned int parentProtocolCount;
    __unsafe_unretained Protocol **parentProtocols = protocol_copyProtocolList(protocol, &parentProtocolCount);
    for (int i = 0; i < parentProtocolCount; i++) {
        Protocol *parentProtocol = parentProtocols[i];
        [conformantProtocols addObjectsFromArray:[self mixinProtocolsConformedToByProtocol:parentProtocol protocolCache:cache]];
    }
    free(parentProtocols);

    //Check self
    const BOOL hasMixinParent = [conformantProtocols count] > 0;
    const BOOL isFirstDegreeMixinProtocol = protocol_conformsToProtocol(protocol, @protocol(BECMixin));
    if (hasMixinParent || isFirstDegreeMixinProtocol) {
        [conformantProtocols insertObject:protocol atIndex:0];
    } else {
        //Protocol is not a mixin. We could cache this to avoid traversing the protocol graph again.
//        [cache addObject:protocol];
    }

    NSLog(@"%s", protocol_getName(protocol));
    return conformantProtocols;
}



#pragma mark - Method adding
+(void)addMethodsInMixinProtocol:(Protocol *)mixinProtocol toClass:(Class)destinationClass
{
    enum {
        classMethods = NO,
        instanceMethods = YES,

    };
    enum {
        optionalMethods = NO,
        requiredMethods = YES,
    };

    //Fetch the method descriptions from the protocols
    unsigned int instanceMethodDescriptionsCount;
    struct objc_method_description *instanceMethodDescriptions = protocol_copyMethodDescriptionList(mixinProtocol, optionalMethods, instanceMethods, &instanceMethodDescriptionsCount);
    unsigned int classMethodDescriptionsCount;
    struct objc_method_description *classMethodDescriptions = protocol_copyMethodDescriptionList(mixinProtocol, optionalMethods, classMethods, &classMethodDescriptionsCount);

    //Add the methods if needed.
    BOOL isEmptyMixin = instanceMethodDescriptionsCount == 0 && classMethodDescriptionsCount == 0;
    if (!isEmptyMixin) {
        Class sourceClass = [self sourseClassForMixinProtocol:mixinProtocol];
        NSAssert(sourceClass != Nil, @"Mixin implementation class not found for mixin <%s>.", protocol_getName(mixinProtocol));

        [self addMethods:instanceMethodDescriptions numberOfMethods:instanceMethodDescriptionsCount fromClass:sourceClass toClass:destinationClass];

        Class metaSourceClass = object_getClass(sourceClass); //[aClass class] does not return the metaclass, it returns aClass.
        Class metaDestinationClass = object_getClass(destinationClass);
        [self addMethods:classMethodDescriptions numberOfMethods:classMethodDescriptionsCount fromClass:metaSourceClass toClass:metaDestinationClass];
    }

    //Tidy up
    free(instanceMethodDescriptions);
    free(classMethodDescriptions);
}



+(void)addMethods:(struct objc_method_description *)methodDescriptions numberOfMethods:(int)numberOfMethods fromClass:(Class)sourceClass toClass:(Class)destinationClass
{
    for (int i=0; i < numberOfMethods; i++) {
        struct objc_method_description methodDescription = methodDescriptions[i];

        NSAssert([sourceClass instancesRespondToSelector:methodDescription.name], @"%s does not implement mixin method %@.", class_getName(sourceClass), NSStringFromSelector(methodDescription.name));

        IMP implementation = class_getMethodImplementation(sourceClass, methodDescription.name);

        //If the class already has a method matching this selector then class_addMethod will not replace the existing method.
        class_addMethod(destinationClass, methodDescription.name, implementation, methodDescription.types);
    }
}



+(Class)sourseClassForMixinProtocol:(Protocol *)mixinProtocol
{
    const char *mixinName = protocol_getName(mixinProtocol);
    Class class = objc_getClass(mixinName);

    return class;
}



#pragma mark - Class enumeration
+(void)enumerateAllClassesUsingBlock:(void(^)(Class class))classEnumerator
{
    int classCount = objc_getClassList(NULL, 0);
    __unsafe_unretained Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class *) * classCount);
    objc_getClassList(classes, classCount);

    for (int i = 0; i < classCount; i++) {
        Class class = classes[i];

        classEnumerator(class);
    }

    free(classes);
}

@end
