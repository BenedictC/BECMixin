//
//  BECDemoMixins.h
//  BECMixin
//
//  Created by Benedict Cohen on 17/12/2013.
//  Copyright (c) 2013 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BECMixin.h"



@protocol BECFirstTestMixin <BECMixin>
@optional
+(void)hello;

-(void)constantMessage;
@end



@protocol BECSecondTestMixin <BECMixin>
@optional
+(void)hello;

-(void)customMessage;
@required
-(NSString *)message;
@end



@protocol BECThirdTestMixin <BECMixin>
@optional
+(void)hello;
-(NSDate *)date;
@end



@protocol BECUnionMixin <BECSecondTestMixin, BECFirstTestMixin>
@end
