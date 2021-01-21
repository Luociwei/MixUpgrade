//
//  ViewController.m
//  MixUpgrade
//
//  Created by Louis Luo on 2020/3/31.
//  Copyright © 2020 Suncode. All rights reserved.
//

#import "ViewController.h"
#import "ExtensionConst.h"
#import <CwGeneralManagerFrameWork/NSString+Extension.h>
#import <CwGeneralManagerFrameWork/FileManager.h>
#import <CwGeneralManagerFrameWork/Alert.h>
#import <CwGeneralManagerFrameWork/Task.h>
#import <CwGeneralManagerFrameWork/TextView.h>
#import <CwGeneralManagerFrameWork/Image.h>
#import <CwGeneralManagerFrameWork/CSVParser.h>

@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *logview;

@property (weak) IBOutlet NSTableView *itemsTableView;
@property (weak) IBOutlet NSTableView *snTableView;
@property (weak) IBOutlet NSTextField *labelPath;
    
@property (nonatomic,strong)Task *vrectReadTask;
    
@property (nonatomic,strong)Task *vrectInputsTask;

@property (nonatomic,strong)TextView *viewCh1;
@property (nonatomic,strong)TextView *viewCh2;
@property (nonatomic,strong)TextView *viewCh3;
@property (nonatomic,strong)TextView *viewCh4;

@property (nonatomic,strong)TextView *textView;

@property (weak) IBOutlet NSPopUpButton *aceBinPopBtn;
@property (weak) IBOutlet NSPopUpButton *mixFwPopBtn;
@property (weak) IBOutlet NSPopUpButton *aceMd5PopBtn;
@property (weak) IBOutlet NSButton *aceUpdateBtn;
@property (weak) IBOutlet NSButton *mixUpdateBtn;

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
@property (copy) NSString *logFilePath;
@property (copy) NSString *mixCheckPath;
//@property (copy) NSString *expPath;
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
    
    [self.isConnectImage1 setImage:[Image cw_getGrayCircleImage]];
    [self.isConnectImage2 setImage:[Image cw_getGrayCircleImage]];
    [self.isConnectImage3 setImage:[Image cw_getGrayCircleImage]];
    [self.isConnectImage4 setImage:[Image cw_getGrayCircleImage]];
    
    self.viewCh1 = [TextView cw_allocInitWithFrame:NSMakeRect(20, 654, 320, 100)];
    [self.view addSubview:self.viewCh1];
    
    self.viewCh2 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 654, 320, 100)];
    [self.view addSubview:self.viewCh2];
    
    self.viewCh3 = [TextView cw_allocInitWithFrame:NSMakeRect(20, 521, 320, 100)];
    [self.view addSubview:self.viewCh3];
    
    self.viewCh4 = [TextView cw_allocInitWithFrame:NSMakeRect(360, 521, 320, 100)];
    [self.view addSubview:self.viewCh4];
    
    self.textView = [TextView cw_allocInitWithFrame:NSMakeRect(20, 10, 660, 250)];
    [self.view addSubview:self.textView];
 
    [self.viewCh1 setPingIpAddress:@"169.254.1.32"];
    [self.viewCh2 setPingIpAddress:@"169.254.1.33"];
    [self.viewCh3 setPingIpAddress:@"169.254.1.34"];
    [self.viewCh4 setPingIpAddress:@"169.254.1.35"];
    NSString *bundlePath = [FileManager cw_getAppResourcePath];
    if (![FileManager cw_isFileExistAtPath:bundlePath]) {
        bundlePath = [[NSBundle mainBundle] resourcePath];
    }
    self.aceCheckPath = [bundlePath stringByAppendingPathComponent:@"AceFW/fwdl_ace_check.exp"];
    self.mixCheckPath = [bundlePath stringByAppendingPathComponent:@"MixFW/fwdl_mix_check.exp"];
    self.aceFwPath = [bundlePath stringByAppendingPathComponent:@"AceFW"];
    self.mixFwPath = [bundlePath stringByAppendingPathComponent:@"MixFW"];
//    self.expPath = [bundlePath stringByAppendingPathComponent:@"AceFW"];
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

    NSString *logPath = [[NSString cw_getUserPath] stringByAppendingPathComponent:@"MixUpgradeLog"];
    [FileManager cw_createFile:logPath isDirectory:YES];
    self.logFilePath = [logPath stringByAppendingPathComponent:@"tempLog.txt"];
    [FileManager cw_createFile:self.logFilePath isDirectory:NO];
    [self getChannelsSate];
    
}



-(void)getChannelsSate{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int i = 0;
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
            i=i+1;
            if (i==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mixUpdateBtn.enabled = YES;
                    self.aceUpdateBtn.enabled = YES;
                    
                });
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
        
        if ([icon containsString:@"off"]) {
            [imageView setImage:[Image cw_getGrayCircleImage]];
        }else{
            [imageView setImage:[Image cw_getGreenCircleImage]];
        }
        //        [imageView setImage:[NSImage imageNamed:icon]];
        
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

-(NSString *)aceUpdateUUT:(NSString *)channel{
    NSString *ip = [self getIpWithUUT:channel];
    NSString *aceExpPath=[self.aceFwPath stringByAppendingPathComponent:@"fwdl_scp.exp"];
    NSString *aceBinPath=[self.aceFwPath stringByAppendingPathComponent:self.aceBinPopBtn.title];
    NSString *aceMd5Path=[self.aceFwPath stringByAppendingPathComponent:self.aceMd5PopBtn.title];
    NSMutableString *info = [[NSMutableString alloc]init];
    NSString *fileName = self.aceBinPopBtn.title;
    BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
    if (checkFileExist) {
        NSString *errorStr =[NSString stringWithFormat:@"%@:%@ was already existed in mix fw.\n",channel,fileName];
        [info appendString:errorStr];
        //            [self.textView showLog:errorStr];
        
    }else{
//        NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
//
//        NSString *log1 = [Task termialWithCmd:cmd1];
//        [NSThread sleepForTimeInterval:1.0];
//        log1  = [FileManager cw_readFromFile:self.logFilePath];

        NSString *md5_cmd =  [NSString stringWithFormat:@"%@ %@ %@\n",aceExpPath,aceMd5Path,ip];
        
        NSString *md5_log = [Task termialWithCmd:md5_cmd];
        [NSThread sleepForTimeInterval:0.5];
        //            log1  = [FileManager cw_readFromFile:self.logFilePath];
        
        [self.textView showLog:md5_log];
        
        NSString *aceBin_cmd = [NSString stringWithFormat:@"%@ %@ %@\n",aceExpPath,aceBinPath,ip];
//        NSString *aceBin_cmd = [NSString stringWithFormat:@"%@ %@ %@ > %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
        NSString *aceBin_log = [Task termialWithCmd:aceBin_cmd];
        [NSThread sleepForTimeInterval:0.5];
//        aceBin_log  = [FileManager cw_readFromFile:self.logFilePath];
        //            [NSThread sleepForTimeInterval:1.0];
        //            log2  = [FileManager cw_readFromFile:self.logFilePath];
        
        [self.textView showLog:aceBin_log];
        
        [info appendString:[NSString stringWithFormat:@"%@:Upgrade Successful.\n",channel]];
        
        //            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
        //
        //                [info appendString:@"UUT1:Upgrade Successful.\n"];
        //            }else{
        //                [info appendString:@"UUT1:Upgrade Fail.\n"];
        //            }
        
    }
    
    return info;
}


- (IBAction)aceUpdate:(id)sender {

    NSMutableString *info = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {
        
        [info appendString:[self aceUpdateUUT:name_UUT1]];
        
    }
    if (self.needUpgradeBtn2.state) {
        [info appendString:[self aceUpdateUUT:name_UUT2]];
    }
    if (self.needUpgradeBtn3.state) {
        [info appendString:[self aceUpdateUUT:name_UUT3]];
    }
    if (self.needUpgradeBtn4.state) {
        [info appendString:[self aceUpdateUUT:name_UUT4]];
    }
    if (!info.length) {
        [info appendString:@"Not Ready,Pls check connect!!"];
    }
    [Alert cw_RemindException:@"Warnning!!!" Information:info];
    
    
}



-(BOOL)checkFile:(NSString *)fileName ip:(NSString *)ip ecpCheckPath:(NSString *)ecpCheckPath{
    
    NSString *cmd = [NSString stringWithFormat:@"%@ %@",ecpCheckPath,ip];
    NSString *log =[Task termialWithCmd:cmd];
    
    [self.textView showLog:log];
    if ([log containsString:fileName]) {
        return YES;
    }
    
    return NO;
    //    NSString *log1 = [Task termialWithCmd:cmd];
    
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
    if (!self.mixUpdateBtn.title.length) {
        return;
    }
 
    NSMutableString *info = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {
        [info appendString:[self mixUpdateUUT:name_UUT1]];
    }
    if (self.needUpgradeBtn2.state) {
        [info appendString:[self mixUpdateUUT:name_UUT2]];
    }
    if (self.needUpgradeBtn3.state) {
        [info appendString:[self mixUpdateUUT:name_UUT3]];
    }
    if (self.needUpgradeBtn4.state) {
        [info appendString:[self mixUpdateUUT:name_UUT4]];
    }
    if (!info.length) {
        [info appendString:@"Not Ready,Pls check connect!!"];
    }
    [Alert cw_RemindException:@"Warnning!!!" Information:info];
    
    
}

-(NSString *)getIpWithUUT:(NSString *)channel{
    NSString *ip = @"";
    if ([channel isEqualToString:name_UUT1]) {
        ip =@"169.254.1.32";
    }else if ([channel isEqualToString:name_UUT2]){
        ip =@"169.254.1.33";
    }else if ([channel isEqualToString:name_UUT3]){
        ip =@"169.254.1.34";
    }else if ([channel isEqualToString:name_UUT4]){
        ip =@"169.254.1.35";
    }
    return ip;
}

-(NSString *)mixUpdateUUT:(NSString *)channel{
    NSString *ip = [self getIpWithUUT:channel];
    
    NSString *fwExpPath=[self.mixFwPath stringByAppendingPathComponent:@"fwdl_scp_mix.exp"];
    NSString *fwTgzPath=[self.mixFwPath stringByAppendingPathComponent:self.mixFwPopBtn.title];
    NSString *fileName = [self getFwCheckVersion:self.mixFwPopBtn.title];
    NSMutableString *info = [[NSMutableString alloc]init];

    BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
    if (checkFileExist) {
        NSString *errorStr =[NSString stringWithFormat:@"%@:%@ was already existed in mix fw.\n",channel,fileName];
        [info appendString:errorStr];
        //            [self.textView showLog:errorStr];
        
    }else{
        //        NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
        //
        //        NSString *log1 = [Task termialWithCmd:cmd1];
        //        [NSThread sleepForTimeInterval:1.0];
        //        log1  = [FileManager cw_readFromFile:self.logFilePath];
        
        NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@\n",fwExpPath,fwTgzPath,ip];
        
        NSString *log = [Task termialWithCmd:cmd];
        //            [NSThread sleepForTimeInterval:1.0];
        //            log2  = [FileManager cw_readFromFile:self.logFilePath];
        
        [self.textView showLog:log];
        [NSThread sleepForTimeInterval:3];
        [info appendString:[NSString stringWithFormat:@"%@:Upgrade Successful.\n",channel]];
        
        //            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
        //
        //                [info appendString:@"UUT1:Upgrade Successful.\n"];
        //            }else{
        //                [info appendString:@"UUT1:Upgrade Fail.\n"];
        //            }
        
    }
    
    return info;
}


@end
