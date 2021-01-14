//
//  ViewController.m
//  SC_Eowyn
//
//  Created by ciwei luo on 2020/3/31.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "ViewController.h"

#import "FileManager.h"
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

@property (nonatomic,strong)TextView *viewCh1;
@property (nonatomic,strong)TextView *viewCh2;
@property (nonatomic,strong)TextView *viewCh3;
@property (nonatomic,strong)TextView *viewCh4;

@property (nonatomic,strong)TextView *textView;

@property (weak) IBOutlet NSPopUpButton *aceBinPopBtn;

@property (weak) IBOutlet NSPopUpButton *aceMd5PopBtn;
@property (weak) IBOutlet NSButton *aceUpdateBtn;

@property (weak) IBOutlet NSButton *needUpgradeBtn1;

@property (weak) IBOutlet NSButton *needUpgradeBtn2;
@property (weak) IBOutlet NSButton *needUpgradeBtn3;
@property (weak) IBOutlet NSButton *needUpgradeBtn4;

@property (weak) IBOutlet NSImageView *isConnectImage1;
@property (weak) IBOutlet NSImageView *isConnectImage2;
@property (weak) IBOutlet NSImageView *isConnectImage3;
@property (weak) IBOutlet NSImageView *isConnectImage4;

@property (copy) NSString *aceFwPath;
@property (copy) NSString *mixFwPath;
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
    
    self.viewCh1 = [TextView cw_allocInitWithFrame:NSMakeRect(20, 680, 320, 100)];
    [self.view addSubview:self.viewCh1];
    
    self.viewCh2 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 680, 320, 100)];
    [self.view addSubview:self.viewCh2];
    
    self.viewCh3 = [TextView cw_allocInitWithFrame:NSMakeRect(20, 550, 320, 100)];
    [self.view addSubview:self.viewCh3];
    
    self.viewCh4 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 550, 320, 100)];
    [self.view addSubview:self.viewCh4];
    
    self.textView = [TextView cw_allocInitWithFrame:NSMakeRect(20, 0, 660, 290)];
    [self.view addSubview:self.textView];
 
    [self.viewCh1 setPingIpAddress:@"169.254.1.32"];
    [self.viewCh2 setPingIpAddress:@"169.254.1.33"];
    [self.viewCh3 setPingIpAddress:@"169.254.1.34"];
    [self.viewCh4 setPingIpAddress:@"169.254.1.35"];
    
    self.aceFwPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"AceFW"];
    NSArray *aceBinFiles = [FileManager cw_getFilenamelistOfType:@"bin" fromDirPath:self.aceFwPath ];
    [self.aceBinPopBtn removeAllItems];
    [self.aceBinPopBtn addItemsWithTitles:aceBinFiles];
    
    NSArray *aceMd5Files = [FileManager cw_getFilenamelistOfType:@"md5" fromDirPath:self.aceFwPath];
    [self.aceMd5PopBtn removeAllItems];
    [self.aceMd5PopBtn addItemsWithTitles:aceMd5Files];
//    rm -rf /users/macbookpro4/.ssh
//    ssh-keygen -l -f ~/.ssh/known_hosts
//    ssh-keygen -R 服务器端的ip地址
    
//    NSLog(@"%@",[Task termialWithCmd:@"rm -rf /users/macbookpro4/.ssh"]);
//    NSLog(@"%@",[Task termialWithCmd:@"ssh-keygen -R 169.254.1.32"]);
//    NSLog(@"%@",[Task termialWithCmd:@"ssh-keygen -R 169.254.1.33"]);
//    NSLog(@"%@",[Task termialWithCmd:@"ssh-keygen -R 169.254.1.34"]);
//    NSLog(@"%@",[Task termialWithCmd:@"ssh-keygen -R 169.254.1.35"]);

    
    [self getChannelsSate];
    
}
-(void)getChannelsSate{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
     
            if (![self getIpState:@"169.254.1.32"]) {
                [self setImageWithImageView:self.isConnectImage1 icon:@"state_off"];
                
                [self setNeedUpgradeBtnState:self.needUpgradeBtn1 isConnect:NO];
                
            }else{
                [self setImageWithImageView:self.isConnectImage1 icon:@"state_on"];

                [self setNeedUpgradeBtnState:self.needUpgradeBtn1 isConnect:YES];
            }
            if (![self getIpState:@"169.254.1.33"]) {
                [self setImageWithImageView:self.isConnectImage2 icon:@"state_off"];
                [self setNeedUpgradeBtnState:self.needUpgradeBtn2 isConnect:NO];
            }else{
                [self setImageWithImageView:self.isConnectImage2 icon:@"state_on"];
                
                [self setNeedUpgradeBtnState:self.needUpgradeBtn2 isConnect:YES];
            }
            
            if (![self getIpState:@"169.254.1.34"]) {
                [self setImageWithImageView:self.isConnectImage3 icon:@"state_off"];
                [self setNeedUpgradeBtnState:self.needUpgradeBtn3 isConnect:NO];
            }else{
                [self setImageWithImageView:self.isConnectImage3 icon:@"state_on"];
  
                [self setNeedUpgradeBtnState:self.needUpgradeBtn3 isConnect:YES];
            }
            if (![self getIpState:@"169.254.1.35"]) {
                [self setImageWithImageView:self.isConnectImage4 icon:@"state_off"];
         
                [self setNeedUpgradeBtnState:self.needUpgradeBtn4 isConnect:NO];
                
            }else{
                [self setImageWithImageView:self.isConnectImage4 icon:@"state_on"];
                [self setNeedUpgradeBtnState:self.needUpgradeBtn4 isConnect:YES];
         
            }
            [NSThread sleepForTimeInterval:0.5];
            
        }
        
        
    });

}

-(void)setNeedUpgradeBtnState:(NSButton *)needUpgradeBtn isConnect:(BOOL)isConnect{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        needUpgradeBtn.state = isConnect;
        needUpgradeBtn.enabled = isConnect;
        
    });
}


-(void)setImageWithImageView:(NSImageView *)imageView icon:(NSString *)icon{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [imageView setImage:[NSImage imageNamed:icon]];
        
    });
}


-(BOOL)getIpState:(NSString *)ip{

    BOOL isOk = NO;
    NSString *pingIP =[NSString stringWithFormat:@"ping %@ -t1",ip];
    NSString *read  = [Task termialWithCmd:pingIP];
    if ([read containsString:@"icmp_seq="]&&[read containsString:@"ttl="]) {
        
        isOk = YES;
    }
    return isOk;
}


- (IBAction)aceUpdate:(id)sender {
    NSString *aceExpPath=[self.aceFwPath stringByAppendingPathComponent:@"fwdl_scp.exp"];
    NSString *aceBinPath=[self.aceFwPath stringByAppendingPathComponent:self.aceBinPopBtn.title];
    if (self.needUpgradeBtn1.state) {

        NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,@"169.254.1.32"];

        NSString *log1 = [Task termialWithCmd:cmd];
        [self.textView showLog:log1];

    }
    if (self.needUpgradeBtn2.state) {
        NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,@"169.254.1.33"];

        NSString *log2 = [Task termialWithCmd:cmd];
        [self.textView showLog:log2];
    }
    if (self.needUpgradeBtn3.state) {
        NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,@"169.254.1.34"];

        NSString *log3 = [Task termialWithCmd:cmd];
        [self.textView showLog:log3];
    }
    if (self.needUpgradeBtn4.state) {
        NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,@"169.254.1.35"];

        NSString *log4 = [Task termialWithCmd:cmd];
        [self.textView showLog:log4];
    }
    
}

- (IBAction)mixUpdate:(id)sender {
}




@end
