//
//  TextView.h
//  MyBase
//
//  Created by ciwei luo on 2020/12/24.
//  Copyright © 2020 macdev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextView : NSView
+(instancetype)cw_allocInitWithFrame:(NSRect)frame;
-(void)showLog:(NSString *)log;
-(void)setPingIpAddress:(NSString *)ip;
@end

NS_ASSUME_NONNULL_END
