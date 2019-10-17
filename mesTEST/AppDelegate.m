//
//  AppDelegate.m
//  mesTEST
//
//  Created by 曹伟东 on 2018/11/5.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //c103 DATA_TEST_1_101
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(IBAction)POSTbtnAction:(id)sender{
    if([GETbtn state]){
        [POSTbtn setState:YES];
        [GETbtn setState:NO];
    }else{
        [POSTbtn setState:NO];
        [GETbtn setState:YES];
    }
}
-(IBAction)GETbtnAction:(id)sender{
    if([POSTbtn state]){
        [POSTbtn setState:NO];
        [GETbtn setState:YES];
    }else{
        [POSTbtn setState:YES];
        [GETbtn setState:NO];
    }
}
-(IBAction)requestbtnAction:(id)sender{
    [showMsgTF setString:@""];
    [statusTF setBackgroundColor:[NSColor systemYellowColor]];
    [statusTF setStringValue:@"Requesting..."];
    //[statusTF setNeedsDisplay];
    NSString *url=[urlTF stringValue];
    if([url length] == 0) return;
    NSString *body=[bodyTF stringValue];
    if([body length] == 0) return;
    [requestBtn setEnabled:NO];
    NSString *method=@"POST";
    if ([GETbtn state]) {
        method=@"GET";
    }
    NSLog(@"Method:%@",method);
    [self testURL:url withBody:body withMethod:method];
}
-(BOOL)testURL:(NSString *) strUrl withBody:(NSString *) strBody withMethod:(NSString *) strMethod{
    // strStation = @"ITKS_A02-2FAP-01_3_CON-OQC";
    static BOOL bResult = false;
    //创建信号量,实现同步请求
    //dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session=[NSURLSession sharedSession];
    //第一步，创建URL
    //NSString *urlString=@"http://10.37.66.2:8005/LuxShare_QualityTestService.aspx";
    //第二步，创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request setHTTPMethod:strMethod];
    [request setTimeoutInterval:5.0f];
    //request.HTTPMethod=@"GET";
    //NSString *strData = [NSString stringWithFormat:@"c=QUERY_RECORD&sn=%@&StationID=%@&cmd=QUERY_PANEL", strSN, strStation];
    [request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];

    //第三步，连接服务器
    NSString static *strReceivedData;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        strReceivedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        strReceivedData=[strReceivedData stringByReplacingOccurrencesOfString:@";" withString:@"\r\n"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知主线程更新
            NSString *strError=[NSString stringWithFormat:@"error:%@",error];
            NSLog(@"%@",strError);
            if(![strError isEqual:@"error:(null)"]) {
                [self->showMsgTF setString:strError];
                [self->statusTF setBackgroundColor:[NSColor systemRedColor]];
                [self->statusTF setStringValue:@"Error."];
            }else{
                [self->showMsgTF setString:strReceivedData];
                [self->statusTF setBackgroundColor:[NSColor systemGreenColor]];
                [self->statusTF setStringValue:@"Done."];
            }
            [self->requestBtn setEnabled:YES];
        });
        if([strReceivedData containsString:@"SN"]){
            bResult = true;
        }
        
        NSLog(@"%@",strReceivedData);
        //发送
        //dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    //等待(阻塞线程)
    //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"task finish");
    return bResult;
}

-(NSString *)getCurrentTime{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"YYYY_MM_dd_HH:mm:ss"];
    [dateFormatter setDateFormat:@"[YYYY/MM/dd HH:mm:ss.sss]"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
}
-(void)windowWillClose:(id)sender{
    [NSApp terminate:NSApp];
}
@end
