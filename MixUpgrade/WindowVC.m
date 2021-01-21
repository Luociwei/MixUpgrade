//
//  WindowVC.m
//  MixUpgrade
//
//  Created by Louis Luo on 2020/3/31.
//  Copyright © 2020 Suncode. All rights reserved.
//

#import "WindowVC.h"
#import "ViewController.h"


@interface WindowVC ()

@end

@implementation WindowVC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self cw_addViewController:[ViewController new]];
    

}



@end
