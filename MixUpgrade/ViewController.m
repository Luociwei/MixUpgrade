//
//  ViewController.m
//  SC_Eowyn
//
//  Created by ciwei luo on 2020/3/31.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "ViewController.h"


#import "FMDB.h"
#import "DataForFMDB.h"
#import "Task.h"
#import "TextView.h"
NSString *vrectInit1 = @"hidreport -v 0x05ac -p 0x041F -i 0 set 0x90 0x90 0x3";

NSString *vrectInit2 = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x82 0x82  0x06  0x2C  0x00  0x00  0x01  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00";

NSString *vrectInit3 = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x88  0x88  0x90  0x36  0x00  0x40  0xFF  0xFF  0xFF  0xFF  0x00  0x00  0x00  0x80";

NSString *vrectCmd = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x82 0x82 0x29 0x20 0x00 0x00 0x01 0x80 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00";
@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *logview;

@property (weak) IBOutlet NSTableView *itemsTableView;
@property (weak) IBOutlet NSTableView *snTableView;
@property (weak) IBOutlet NSTextField *labelPath;
@property (nonatomic, strong) FMDatabase *db;
    
@property (nonatomic,strong)Task *vrectReadTask;
    
@property (nonatomic,strong)Task *vrectInputsTask;

@property (nonatomic,strong)TextView *view1;
@property (nonatomic,strong)TextView *view2;
@property (nonatomic,strong)TextView *view3;
@property (nonatomic,strong)TextView *view4;

@end

@implementation ViewController

//- (IBAction)vrect:(NSButton *)sender {
//
//    [self.vrectReadTask send:vrectCmd];
//    NSString *read = [self.vrectReadTask cw_read];
//    self.logview.string = read;
//
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view1 = [TextView cw_allocInitWithFrame:NSMakeRect(19, 191, 320, 157)];
    [self.view addSubview:self.view1];
    
    self.view2 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 191, 320, 157)];
    [self.view addSubview:self.view2];
    
    self.view3 = [TextView cw_allocInitWithFrame:NSMakeRect(19, 15, 320, 157)];
    [self.view addSubview:self.view3];
    
    self.view4 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 13, 320, 157)];
    [self.view addSubview:self.view4];
    
//    _vrectReadTask =[[PythonTask alloc] initWithLauchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c",@"hidreport -v 0x05ac -p 0x041F -i 3 inputs", nil]];
////
//    _vrectInputsTask =[[PythonTask alloc] initWithLauchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c",vrectInit1,vrectInit2,vrectInit3,nil]];

    [self.view1 setPingIpAddress:@"169.254.1.32"];
    [self.view2 setPingIpAddress:@"169.254.1.33"];
    [self.view3 setPingIpAddress:@"169.254.1.34"];
    [self.view4 setPingIpAddress:@"169.254.1.35"];
  
    
}




@end
