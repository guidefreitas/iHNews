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
#import "PostDownloader.h"

@interface BrowserViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    UIWebView *webView;
    NSURL *url;
    NSString *siteData;
    NSNumber *postId;
    PostDownloader *postDownloader;
}

@property (retain) NSString *siteData;
@property (retain) NSURL *url;
@property (retain) NSNumber *postId;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(IBAction)showActionSheet:(id)sender;


@end
