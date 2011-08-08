//
//  BrowserViewController.m
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "BrowserViewController.h"


@implementation BrowserViewController

@synthesize webView;
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)showActionSheet:(id)sender{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", @"Send by Email", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"clickeed");
    if (buttonIndex == 0) {
        [FlurryAPI logEvent:@"Screen - Browser - Action - Open Safari"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if(buttonIndex == 1){
        [FlurryAPI logEvent:@"Screen - Browser - Action - Send Mail"];
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"iHN - Link" ];
        NSString *msgBody = [[NSString alloc] initWithFormat:@"iHN - %@", [[self url] absoluteString]]; 
        [controller setMessageBody:msgBody isHTML:NO]; 
        if (controller) [self presentModalViewController:controller animated:YES];
        [controller release];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"Open Screen - Browser"];
    [FlurryAPI logPageView];
    self.title = @"Browser";
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnActionClicked:)];
    
    self.navigationItem.rightBarButtonItem = actionButton;
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];

    // Do any additional setup after loading the view from its nib.
}

-(void)btnActionClicked:(id)sender{
    [self showActionSheet:sender];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
