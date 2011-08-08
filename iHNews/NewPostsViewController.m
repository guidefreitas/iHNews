//
//  NewPostsViewController.m
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "NewPostsViewController.h"
#import "ASIHTTPRequest.h"
#include "JSON.h"
#include "PostInfoViewController.h"
#import "SVProgressHUD.h"

@implementation NewPostsViewController

@synthesize postCell;

@synthesize _dataNews;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

-(void)RefreshNewPosts{
    
     [SVProgressHUD showInView:self.view];
    
    NSURL *url = [NSURL URLWithString:@"http://api.ihackernews.com/new"];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        
        NSMutableArray *data = [responseString JSONValue];
        
        if(!data){
            [FlurryAPI logEvent:@"Screen - New Posts - Network Error (invalid data)"];
            [SVProgressHUD dismissWithError:@"Network error"];
        }
        
        _dataNews = [data objectForKey:@"items"];
        [_dataNews retain];
        
        [SVProgressHUD dismiss];
        [[self tableView] reloadData];
        
        
        
    }];
    [request setFailedBlock:^{
        [FlurryAPI logEvent:@"Screen - New Posts - Network Error (connection error)"];
        [SVProgressHUD dismissWithError:@"Network error"];
    }];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"Open Screen - New Posts"];
    [FlurryAPI logPageView];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];
    
    self.navigationItem.leftBarButtonItem = refreshButton;
    [refreshButton release];
    self.tableView.rowHeight = 120.0f;
    
    [self RefreshNewPosts];
}

-(void) btnRefreshClicked:(id)sender{
     [FlurryAPI logEvent:@"Screen - New Posts - Refresh Button Clicked"];
    [self RefreshNewPosts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_dataNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PostCell *cell = (PostCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = postCell;
        self.postCell = nil;
    }
    
    NSDictionary *obj = [_dataNews objectAtIndex:indexPath.row];
    if(obj){
        
        cell.textLabel.text = [obj objectForKey:@"title"];
        cell.descriptionLabel.text =  [[[NSString alloc] initWithFormat:@"%@ points and %@ comments", [obj objectForKey:@"points"] ,[obj objectForKey:@"commentCount"]] autorelease]; 
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
    if([_dataNews count] != 0){
        
        PostInfoViewController *postInfo = [[PostInfoViewController alloc] init];
        
        NSDictionary *obj = [_dataNews objectAtIndex:indexPath.row];
        
        postInfo.postId = [obj objectForKey:@"id"];
        
        [self.navigationController pushViewController:postInfo animated:YES];
        [postInfo release];
        
    }
}

@end
