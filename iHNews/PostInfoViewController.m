//
//  PostInfoViewController.m
//  iHNews
//
//  Created by Guilherme Juraszek on 07/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "PostInfoViewController.h"
#import "ASIHTTPRequest.h"
#include "JSON.h"
#include "BrowserViewController.h"
#include "NSString+HTML.h"
#import "SVProgressHUD.h"
#import "FullCommentViewController.h"
#import "BrowserViewController.h"
#import "Comment.h"

@implementation PostInfoViewController

@synthesize post;
@synthesize comments;
@synthesize loadedPanel;
@synthesize loadingPanel;
@synthesize postId;
@synthesize postCell;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)OpenBrowser{
    
    BrowserViewController *browser = [[BrowserViewController alloc] init];
    browser.managedObjectContext = self.managedObjectContext;
    browser.postId = post.id;
    NSString *urlString = post.url;
    NSURL *url = [NSURL URLWithString:urlString];
    browser.url = url;
    browser.siteData = post.page;
    
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];

}

-(void) LoadNewData:(NSNumber *) _newId{
    /*
    [SVProgressHUD showInView:self.view];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://api.ihackernews.com/post/%@", _newId];
    NSLog(@"Opening URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [urlString release];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        
        postData = [responseString JSONValue];
        [postData retain];
        
        if(!postData){
            [SVProgressHUD dismissWithError:@"Network error"];
        }else{
            comments = [postData objectForKey:@"comments"];
            [comments retain];
            
            UIBarButtonItem *browserButton = [[UIBarButtonItem alloc] initWithTitle:@"Browser" style:UIBarButtonItemStyleDone target:self action:@selector(btnBrowserClicked:)];
            
            self.navigationItem.rightBarButtonItem = browserButton;
            [browserButton release];
            
            [SVProgressHUD dismiss];
            [[self tableView] reloadData];
            
        }
        
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismissWithError:@"Network error"];
    }];
    [request startAsynchronous];
     */
    
    
    
}

- (void) btnBrowserClicked:(id)sender{
    
    [self OpenBrowser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"Open Screen - Post Info"];
    [FlurryAPI logPageView];
    
    UIBarButtonItem *browserButton = [[UIBarButtonItem alloc] initWithTitle:@"Browser" style:UIBarButtonItemStyleDone target:self action:@selector(btnBrowserClicked:)];
    
    self.navigationItem.rightBarButtonItem = browserButton;
    [browserButton release];
    
    self.tableView.rowHeight = 100.0f;
    
    /*
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)] autorelease];
    headerLabel.text = @"HEADER";
    
    [containerView addSubview:headerLabel];
    [self.view addSubview:containerView];
    */
    

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return [NSString stringWithFormat:@"Post"];
    }
    if(section == 1){
        return [NSString stringWithFormat:@"Comments"];
    }
    
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([comments count] != 0){
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostInfoCell";
    
    PostInfoCell *cell = (PostInfoCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PostInfoCell" owner:self options:nil];
        cell = postCell;
        self.postCell = nil;
    }
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            cell.textLabel.text = post.title;
            NSString *description = [[NSString alloc] initWithFormat:@"Posted %@ by %@", post.postedAgo, post.user];
            cell.detailLabel.text = description;
            [description release];
        }
    
        
    }
    
    if(indexPath.section == 1){

        Comment *comment = [comments objectAtIndex:[indexPath row]];
        NSString *stringHtml = [[NSString alloc] initWithFormat:@"%@", comment.content];
        
        cell.textLabel.text = [stringHtml stringByConvertingHTMLToPlainText];
        [stringHtml release];
        
        NSString *description = [[NSString alloc] initWithFormat:@"Posted %@ by %@", comment.postedAgo, comment.user];
        
        cell.detailLabel.text = description;
        [description release];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        [self OpenBrowser];
    }
    
    if(indexPath.section == 1){
        Comment *comment = [comments objectAtIndex:indexPath.row];
        NSString *stringHtml = [[NSString alloc] initWithFormat:@"%@", comment.content];
        
        FullCommentViewController *fullCommentView = [[FullCommentViewController alloc] init];
        fullCommentView.commentString = [stringHtml stringByConvertingHTMLToPlainText];
        [stringHtml release];
        
        NSString *description = [[NSString alloc] initWithFormat:@"Posted %@ by %@", comment.postedAgo, comment.user];
        fullCommentView.descriptionString = description;
        [description release];
        
        [self.navigationController pushViewController:fullCommentView animated:YES];
        //[stringHtml release];
        [fullCommentView release];
    }
}

@end
