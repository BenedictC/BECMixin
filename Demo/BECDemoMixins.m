//
//  BECDemoMixins.m
//  BECMixin
//
//  Created by Benedict Cohen on 17/12/2013.
//  Copyright (c) 2013 Benedict Cohen. All rights reserved.
//

#import "BECDemoMixins.h"



@interface BECFirstTestMixin : NSObject
@end

//This class must implement all of the optional methods in the BECUnionMixin protocol
@implementation BECFirstTestMixin

+(void)hello
{
    NSLog(@"%s: %@", __FUNCTION__, self);
}



-(void)constantMessage
{
    NSLog(@"%s: %@", __FUNCTION__, self);
}

@end



@interface BECSecondTestMixin : NSObject
@end

//This class must implement all of the optional methods in the BECUnionMixin protocol
@implementation BECSecondTestMixin

+(void)hello
{
    NSLog(@"%s: %@", __FUNCTION__, self);
}



-(void)customMessage
{
    //This ugly cast allows us to call mixin methods.
    id<BECSecondTestMixin> mixinSelf = (id)self;

    NSLog(@"%@", [mixinSelf message]);
}

@end



@interface BECThirdTestMixin : NSObject
@end



@implementation BECThirdTestMixin

+(void)hello
{
    NSLog(@"%s: %@", __FUNCTION__, self);
}



-(NSDate *)date
{
    return [NSDate date];
}

@end
