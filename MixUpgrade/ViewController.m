//
//  ViewController.m
//  MixUpgrade
//
//  Created by Louis Luo on 2020/3/31.
//  Copyright © 2020 Suncode. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Extension.h"
#import "Alert.h"
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
@property (weak) IBOutlet NSPopUpButton *mixFwPopBtn;


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
@property (copy) NSString *aceCheckPath;
@property (copy) NSString *mixCheckPath;
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
    self.aceCheckPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"AceFW/fwdl_ace_check.exp"];
    self.mixCheckPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"MixFW/fwdl_mix_check.exp"];
    self.aceFwPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"AceFW"];
    self.mixFwPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"MixFW"];
    NSArray *aceBinFiles = [FileManager cw_getFilenamelistOfType:@"bin" fromDirPath:self.aceFwPath ];
    [self.aceBinPopBtn removeAllItems];
    [self.aceBinPopBtn addItemsWithTitles:aceBinFiles];
    
    NSArray *aceMd5Files = [FileManager cw_getFilenamelistOfType:@"md5" fromDirPath:self.aceFwPath];
    [self.aceMd5PopBtn removeAllItems];
    [self.aceMd5PopBtn addItemsWithTitles:aceMd5Files];
    
    NSArray *mixFwFiles = [FileManager cw_getFilenamelistOfType:@"tgz" fromDirPath:self.mixFwPath];
    [self.mixFwPopBtn removeAllItems];
    [self.mixFwPopBtn addItemsWithTitles:mixFwFiles];
    
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
            [NSThread sleepForTimeInterval:0.3];
            
        }
        
        
    });

}

-(void)setNeedUpgradeBtnState:(NSButton *)needUpgradeBtn isConnect:(BOOL)isConnect{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        needUpgradeBtn.state = isConnect;
//        needUpgradeBtn.enabled = isConnect;
        
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

-(BOOL)checkFile:(NSString *)fileName ip:(NSString *)ip ecpCheckPath:(NSString *)ecpCheckPath{

    NSString *cmd = [NSString stringWithFormat:@"%@ %@",ecpCheckPath,ip];
    NSString *log =[Task termialWithCmd:cmd];
    
    
    if ([log containsString:fileName]) {
        return YES;
    }
    
    return NO;
//    NSString *log1 = [Task termialWithCmd:cmd];
    
}
- (IBAction)aceUpdate:(id)sender {
    NSString *aceExpPath=[self.aceFwPath stringByAppendingPathComponent:@"fwdl_scp.exp"];
    NSString *aceBinPath=[self.aceFwPath stringByAppendingPathComponent:self.aceBinPopBtn.title];
    NSString *fileName = self.aceBinPopBtn.title;
    NSMutableString *errorInfo = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {

        NSString *ip =@"169.254.1.32";
        
         BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT1:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }

    }
    if (self.needUpgradeBtn2.state) {
        
        NSString *ip =@"169.254.1.33";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT2:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
            
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn3.state) {
        
        NSString *ip =@"169.254.1.34";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT3:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn4.state) {
        
        NSString *ip =@"169.254.1.35";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT4:%@ was existed in mix fw,no need to be updated",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",aceExpPath,aceBinPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    
//    if (errorInfo.length) {
//        [Alert cw_messageBox:@"Warning" Information:errorInfo];
//    }
    
}


-(NSString *)getFwCheckVersion:(NSString *)fwName{
    
    NSArray *arr1 = [fwName cw_componentsSeparatedByString:@"_"];
    if (arr1.count) {
        NSArray *arr2 = [arr1.lastObject cw_componentsSeparatedByString:@"."];
        if (arr2.count) {
            NSString *version = [NSString stringWithFormat:@"\"MIX_FW_PACKAGE\":\"%@\"",arr2.firstObject];
            return version;
        }
    }
    
  
    
    return @"";
}

- (IBAction)mixUpdate:(id)sender {
    NSString *fwExpPath=[self.mixFwPath stringByAppendingPathComponent:@"fwdl_scp_mix.exp"];
    NSString *fwTgzPath=[self.mixFwPath stringByAppendingPathComponent:self.mixFwPopBtn.title];
    NSString *fileName = [self getFwCheckVersion:self.mixFwPopBtn.title];
    NSMutableString *errorInfo = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {
        
        NSString *ip =@"169.254.1.32";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT1:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",fwExpPath,fwTgzPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn2.state) {
        
        NSString *ip =@"169.254.1.33";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT2:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
            
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",fwExpPath,fwTgzPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn3.state) {
        
        NSString *ip =@"169.254.1.34";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT3:%@ was existed in mix fw,no need to be updated\n",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",fwExpPath,fwTgzPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn4.state) {
        
        NSString *ip =@"169.254.1.35";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT4:%@ was existed in mix fw,no need to be updated",fileName];
            [self.textView showLog:errorStr];
            [errorInfo appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@",fwExpPath,fwTgzPath,ip];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [self.textView showLog:log1];
        }
        
    }
    
    //    if (errorInfo.length) {
    //        [Alert cw_messageBox:@"Warning" Information:errorInfo];
    //    }
    
}




@end
