//
//  main.m
//  BECMixin
//
//  Created by Benedict Cohen on 17/12/2013.
//  Copyright (c) 2013 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BECDemoMixins.h"



@interface BECObject : NSObject <BECUnionMixin>
@end

@implementation BECObject

-(NSString *)message
{
    return [@"Hello from " stringByAppendingString:NSStringFromClass([self class])];
}

@end



int main(int argc, const char * argv[])
{

    @autoreleasepool {
        [BECObject hello];
        [[BECObject new] constantMessage];
        [[BECObject new] customMessage];
    }
    return 0;
}

