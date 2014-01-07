//
//  BECDemoObject.m
//  BECMixin
//
//  Created by Benedict Cohen on 07/01/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BECDemoObject.h"


@interface BECDemoObject () <BECThirdTestMixin>
@end



@implementation BECDemoObject

-(NSString *)message
{
    NSDate *date = [self date];
    return [@"Hello at " stringByAppendingString:[date description]];
}

@end

