//
//  ViewController.m
//  MixUpgrade
//
//  Created by Louis Luo on 2020/3/31.
//  Copyright © 2020 Suncode. All rights reserved.
//

#import "ViewController.h"
#import <CwGeneralManagerFrameWork/NSString+Extension.h>
#import <CwGeneralManagerFrameWork/FileManager.h>
#import <CwGeneralManagerFrameWork/Alert.h>
#import <CwGeneralManagerFrameWork/Task.h>
#import <CwGeneralManagerFrameWork/TextView.h>
#import <CwGeneralManagerFrameWork/Image.h>
#import <CwGeneralManagerFrameWork/CSVParser.h>

NSString *vrectInit1 = @"hidreport -v 0x05ac -p 0x041F -i 0 set 0x90 0x90 0x3";

NSString *vrectInit2 = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x82 0x82  0x06  0x2C  0x00  0x00  0x01  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00  0x00";

NSString *vrectInit3 = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x88  0x88  0x90  0x36  0x00  0x40  0xFF  0xFF  0xFF  0xFF  0x00  0x00  0x00  0x80";

NSString *vrectCmd = @"hidreport -v 0x05ac -p 0x041F -i 3 set 0x82 0x82 0x29 0x20 0x00 0x00 0x01 0x80 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00";
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
@property (weak) IBOutlet NSPopUpButton *aceMd5PopBtn;
@property (weak) IBOutlet NSPopUpButton *mixFwPopBtn;

@property (weak) IBOutlet NSButton *mixUpdateBtn;

@property (weak) IBOutlet NSButton *aceUpdateBtn;

@property (weak) IBOutlet NSButton *needUpgradeBtn1;

@property (weak) IBOutlet NSButton *needUpgradeBtn2;
@property (weak) IBOutlet NSButton *needUpgradeBtn3;
@property (weak) IBOutlet NSButton *needUpgradeBtn4;

@property (weak) IBOutlet NSImageView *isConnectImage1;
@property (weak) IBOutlet NSImageView *isConnectImage2;
@property (weak) IBOutlet NSImageView *isConnectImage3;
@property (weak) IBOutlet NSImageView *isConnectImage4;
@property (copy) NSString *expPath;
@property (copy) NSString *aceFwPath;
@property (copy) NSString *mixFwPath;
@property (copy) NSString *aceCheckPath;
@property (copy) NSString *mixCheckPath;
@property (copy) NSString *logFilePath;
@end

@implementation ViewController

-(void)parserCSV{
    
    
    NSString *path = @"/Users/ciweiluo/Desktop/SC371_FCT__Baseboard_20210120.csv";
    NSString *csv = [FileManager cw_readFromFile:@"/Users/ciweiluo/Desktop/SC371_FCT__Baseboard_20210120.csv"];
    CSVParser *parser=  [[CSVParser alloc] init];
    if ([parser openFile:path]) {
        NSArray *scriptArray = [parser parseFile];
        NSMutableString *contentArr = [[NSMutableString alloc]init];
        for (int i =0; i<scriptArray.count; i++) {
            
            NSArray *arr = scriptArray[i];
            for (int j=0; j<arr.count; j++) {
                [contentArr appendString:arr[j]];
                if (j!=arr.count-1) {
                    [contentArr appendString:@","];
                }
                
                if (j==1) {
                    [contentArr appendString:@","];
                }
            }
            
            [contentArr appendString:@"\n"];
            
        }
        
        
        [FileManager cw_writeToFile:@"/Users/ciweiluo/Desktop/new.csv" content:contentArr];
    }
    
    
}

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
    
    self.textView = [TextView cw_allocInitWithFrame:NSMakeRect(20, 0, 660, 264)];
    [self.view addSubview:self.textView];
 
    [self.viewCh1 setPingIpAddress:@"169.254.1.32"];
    [self.viewCh2 setPingIpAddress:@"169.254.1.33"];
    [self.viewCh3 setPingIpAddress:@"169.254.1.34"];
    [self.viewCh4 setPingIpAddress:@"169.254.1.35"];
    NSString *bundlePath = [FileManager cw_getAppResourcePath];
    if (![FileManager cw_isFileExistAtPath:bundlePath]) {
        bundlePath = [[NSBundle mainBundle] resourcePath];
    }
    [self.textView showLog:bundlePath];
    [self.textView showLog:[[NSBundle mainBundle] resourcePath]];
    self.aceCheckPath = [bundlePath stringByAppendingPathComponent:@"Exp/fwdl_ace_check.exp"];
    self.mixCheckPath = [bundlePath stringByAppendingPathComponent:@"Exp/fwdl_mix_check.exp"];
    self.aceFwPath = [bundlePath stringByAppendingPathComponent:@"AceFW"];
    self.mixFwPath = [bundlePath stringByAppendingPathComponent:@"MixFW"];
    self.expPath = [bundlePath stringByAppendingPathComponent:@"Exp"];
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
- (IBAction)aceUpdate:(id)sender {
    NSString *aceExpPath=[self.expPath stringByAppendingPathComponent:@"fwdl_scp.exp"];
    NSString *aceBinPath=[self.aceFwPath stringByAppendingPathComponent:self.aceBinPopBtn.title];
    NSString *aceMd5Path=[self.aceFwPath stringByAppendingPathComponent:self.aceMd5PopBtn.title];
    NSString *fileName = self.aceBinPopBtn.title;
    NSMutableString *info = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {
        
        NSString *ip =@"169.254.1.32";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (!checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT1:%@ was already existed in mix fw.\n",fileName];
            [info appendString:errorStr];
//            [self.textView showLog:errorStr];
            
        }else{
            NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd1];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log1];
            
            NSString *cmd2 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceMd5Path,ip,self.logFilePath];
            
            NSString *log2 = [Task termialWithCmd:cmd2];
            [NSThread sleepForTimeInterval:1.0];
            log2  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log2];
            
            
            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT1:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT1:Upgrade Fail.\n"];
            }
            
        }
        
    }
    
    if (self.needUpgradeBtn2.state) {

        NSString *ip =@"169.254.1.33";

        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT2:%@ was already existed in mix fw.\n",fileName];
//            [self.textView showLog:errorStr];
            [info appendString:errorStr];

        }else{
            NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd1];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log1];
            
            NSString *cmd2 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceMd5Path,ip,self.logFilePath];
            
            NSString *log2 = [Task termialWithCmd:cmd2];
            [NSThread sleepForTimeInterval:1.0];
            log2  = [FileManager cw_readFromFile:self.logFilePath];

            [self.textView showLog:log2];
            
            
            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT2:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT2:Upgrade Fail.\n"];
            }
            
        }

    }

    if (self.needUpgradeBtn3.state) {

        NSString *ip =@"169.254.1.34";

        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (!checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT3:%@ was already existed in mix fw.\n",fileName];
//            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
//            NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@\n",aceExpPath,aceBinPath,ip];
            NSString *log1 = [Task termialWithCmd:cmd1];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log1];
            
            NSString *cmd2 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceMd5Path,ip,self.logFilePath];
//            NSString *cmd2 = [NSString stringWithFormat:@"%@ %@ %@\n",aceExpPath,aceMd5Path,ip];
            NSString *log2 = [Task termialWithCmd:cmd2];
            [NSThread sleepForTimeInterval:1.0];
            log2  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log2];
            
            
            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT3:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT3:Upgrade Fail.\n"];
            }
            
        }

    }
    if (self.needUpgradeBtn4.state) {

        NSString *ip =@"169.254.1.35";

        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.aceCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT4:%@ was already existed in mix fw.\n",fileName];
//            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd1 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceBinPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd1];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log1];
            
            NSString *cmd2 = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",aceExpPath,aceMd5Path,ip,self.logFilePath];
            
            NSString *log2 = [Task termialWithCmd:cmd2];
            [NSThread sleepForTimeInterval:1.0];
            log2  = [FileManager cw_readFromFile:self.logFilePath];
            
            [self.textView showLog:log2];
            
            
            if ([log2 containsString:@"100%"]&&[log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT4:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT4:Upgrade Fail.\n"];
            }
            
        }

    }
    if (!info.length) {
        [info appendString:@"Not Ready,Pls check connect!!"];
    }
    [Alert cw_RemindException:@"Warnning!!!" Information:info];
    
    
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
    NSString *fwExpPath=[self.expPath stringByAppendingPathComponent:@"fwdl_scp_mix.exp"];
    NSString *fwTgzPath=[self.mixFwPath stringByAppendingPathComponent:self.mixFwPopBtn.title];
    NSString *fileName = [self getFwCheckVersion:self.mixFwPopBtn.title];
    NSMutableString *info = [[NSMutableString alloc]init];
    if (self.needUpgradeBtn1.state) {
        
        NSString *ip =@"169.254.1.32";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT1:%@ was already existed in mix fw.\n",fileName];
            //            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",fwExpPath,fwTgzPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            if ([log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT1:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT1:Upgrade Fail.\n"];
            }
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn2.state) {
        
        NSString *ip =@"169.254.1.33";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT2:%@ was already existed in mix fw.\n",fileName];
            //            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",fwExpPath,fwTgzPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            if ([log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT2:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT2:Upgrade Fail.\n"];
            }
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn3.state) {
        
        NSString *ip =@"169.254.1.34";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT3:%@ was already existed in mix fw.\n",fileName];
            //            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",fwExpPath,fwTgzPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            if ([log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT3:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT3:Upgrade Fail.\n"];
            }
            [self.textView showLog:log1];
        }
        
    }
    if (self.needUpgradeBtn4.state) {
        
        NSString *ip =@"169.254.1.35";
        
        BOOL checkFileExist = [self checkFile:fileName ip:ip ecpCheckPath:self.mixCheckPath];
        if (checkFileExist) {
            NSString *errorStr =[NSString stringWithFormat:@"UUT4:%@ was already existed in mix fw.\n",fileName];
            //            [self.textView showLog:errorStr];
            [info appendString:errorStr];
        }else{
            NSString *cmd = [NSString stringWithFormat:@"%@ %@ %@ >& %@\n",fwExpPath,fwTgzPath,ip,self.logFilePath];
            
            NSString *log1 = [Task termialWithCmd:cmd];
            [NSThread sleepForTimeInterval:1.0];
            log1  = [FileManager cw_readFromFile:self.logFilePath];
            if ([log1 containsString:@"100%"]) {
                
                [info appendString:@"UUT4:Upgrade Successful.\n"];
            }else{
                [info appendString:@"UUT4:Upgrade Fail.\n"];
            }
            [self.textView showLog:log1];
        }
        
    }
    if (!info.length) {
        [info appendString:@"Not Ready,Pls check connect!!"];
    }
    [Alert cw_RemindException:@"Warnning!!!" Information:info];
    

}




@end
