//
//  main.m
//  BECMixin
//
//  Created by Benedict Cohen on 17/12/2013.
//  Copyright (c) 2013 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BECDemoObject.h"





int main(int argc, const char * argv[])
{

    @autoreleasepool {
        [BECDemoObject hello];
        [[BECDemoObject new] constantMessage];
        [[BECDemoObject new] customMessage];
    }
    return 0;
}

