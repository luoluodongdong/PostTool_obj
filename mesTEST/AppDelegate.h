//
//  AppDelegate.h
//  mesTEST
//
//  Created by 曹伟东 on 2018/11/5.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSButton *POSTbtn;
    IBOutlet NSButton *GETbtn;
    IBOutlet NSButton *requestBtn;
    IBOutlet NSTextField *urlTF;
    IBOutlet NSTextField *bodyTF;
    IBOutlet NSTextView *showMsgTF;
    IBOutlet NSTextField *statusTF;
   
}
-(IBAction)requestbtnAction:(id)sender;
-(IBAction)POSTbtnAction:(id)sender;
-(IBAction)GETbtnAction:(id)sender;
@end

