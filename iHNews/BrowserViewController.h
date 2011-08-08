//
//  BrowserViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 
#import "FlurryAPI.h"

@interface BrowserViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    UIWebView *webView;
    NSURL *url;
}

@property (retain) NSURL *url;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

-(IBAction)showActionSheet:(id)sender;


@end
