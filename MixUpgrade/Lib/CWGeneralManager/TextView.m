//
//  TextView.m
//  MyBase
//
//  Created by ciwei luo on 2020/12/24.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "TextView.h"
//#import "CWGeneralManager.h"
#import "NSString+Extension.h"
@interface TextView ()
@property (strong,nonatomic)NSMutableString *mutLogString;
@property (nonatomic, strong) NSTextView *logTextView;
//@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (nonatomic, strong) NSScrollView *scrollView;
@end


@implementation TextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
//    self.scrollView.bounds = dirtyRect;
}


+(instancetype)cw_allocInitWithFrame:(NSRect)frame{
    TextView *view = [[self alloc]initWithFrame:frame];
    return view;
}


-(void)layout{
    [super layout];
    
    self.scrollView.frame = self.bounds;
    self.logTextView.frame = self.scrollView.bounds;
}



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if  (self) {
        // Initialization code here
        
        self.scrollView = [[NSScrollView alloc]initWithFrame:frame];
        self.scrollView.wantsLayer = YES;
        self.scrollView.layer.backgroundColor = [NSColor redColor].CGColor;
        [self.scrollView setBorderType:NSNoBorder];
        [self.scrollView setHasVerticalScroller:YES];
        [self.scrollView setHasHorizontalScroller:YES];
        [self.scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        
        [self addSubview:self.scrollView];

        
        self.logTextView = [[NSTextView alloc]initWithFrame:self.scrollView.bounds];
//        [self.logTextView setMinSize:NSMakeSize(0.0, frame.size.height - 80)];
//        [self.logTextView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
//        [self.logTextView setVerticallyResizable:YES];
//        [self.logTextView setHorizontallyResizable:NO];
//        [self.logTextView setAutoresizingMask:NSViewWidthSizable];
//        [[self.logTextView textContainer]setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
//        [[self.logTextView textContainer]setWidthTracksTextView:YES];
//        [self.logTextView setFont:[NSFont fontWithName:@"PingFang-SC-Regular" size:12.0]];
        [self.logTextView setEditable:YES];
        
        [self.scrollView setDocumentView:self.logTextView];
      
        
        
        
        NSButton *btn = [NSButton buttonWithImage:[NSImage imageNamed:@"recycle"] target:self action:@selector(clean:)];
        btn.bezelStyle = NSBezelStyleRegularSquare;
        btn.bordered = NO;
//        btn.frame = NSMakeRect(0, 0, 20, 20);
        [self addSubview:btn];
    }
    
    return  self;
}



- (void)clean:(NSButton *)sender {
    self.mutLogString=nil;
    [self.mutLogString appendString:@"Clean..................\n"];
    self.logTextView.string = @"";
    
}


//+(void)postNotificationWithLog:(NSString *)log type:(NSString *)type{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:log forKey:@"log"];
//    [dic setObject:type forKey:@"type"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowingLogVCWillPrintLog" object:nil userInfo:dic];
//}

-(void)showLog:(NSString *)log
{
  
    NSString *timeString = [NSString cw_stringFromCurrentDateTimeWithMicrosecond];
    [self.mutLogString appendString:[NSString stringWithFormat:@"%@ %@\n",timeString,log]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logTextView.string = self.mutLogString;
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.string.length, 1)];
    });
}

-(void)showLog1:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *log = [dic objectForKey:@"log"];
    NSString *type = [dic objectForKey:@"type"];
    NSString *timeString = [NSString cw_stringFromCurrentDateTimeWithMicrosecond];
    [self.mutLogString appendString:[NSString stringWithFormat:@"%@ %@ %@\n",timeString,type,log]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logTextView.string = self.mutLogString;
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.string.length, 1)];
    });
}
- (IBAction)filtre:(NSSearchField *)sender {
    NSLog(@"%@",self.mutLogString);
    
    NSString *strSearch = sender.stringValue;
    
    if (!strSearch.length) {
        self.logTextView.string = self.mutLogString;
        return;
    }
    NSArray *strArr = [self.mutLogString cw_componentsSeparatedByString:@"\n"];
    NSMutableString *filterStr = [NSMutableString string];
    for (NSString *str in strArr) {
        if ([str.lowercaseString containsString:strSearch.lowercaseString]) {
            [filterStr appendString:str];
            [filterStr appendString:@"\n"];
        }
    }
    self.logTextView.string = filterStr;
    
}


-(NSMutableString *)mutLogString{
    if (_mutLogString==nil) {
        _mutLogString = [[NSMutableString alloc]init];
    }
    return _mutLogString;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setPingIpAddress:(NSString *)ip{
    //    if ([self.title containsString:@"1"]) {
    //        return;
    //    }
    NSString *ip_address = [NSString stringWithFormat:@"ping %@",ip];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/sh"];
        
        [task setArguments:[NSArray arrayWithObjects:@"-c",ip_address, nil]];
        //        NSData *readData = nil;
        NSPipe* nsreadPipe = [NSPipe pipe];
        NSFileHandle *nsreadHandle = [nsreadPipe fileHandleForReading];
        [task setStandardOutput: nsreadPipe];
        [task launch];
        
        while (1)
        {
            
            NSData *readData = [nsreadHandle availableData];
            if (readData.length) {
                NSString *reply = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
                
                
                [self showLog:reply];
                
                
            }else{
                break;
            }
            
            
            [NSThread sleepForTimeInterval:0.5];
        }
    });
}


@end
