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

@implementation PostInfoViewController

@synthesize loadedPanel;
@synthesize loadingPanel;
@synthesize postId;
@synthesize postCell;

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
    NSString *urlString = [postData objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    browser.url = url;
    
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];

}

-(void) LoadNewData:(NSNumber *) _newId{
    [SVProgressHUD showInView:self.view];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://api.ihackernews.com/post/%@", _newId];
    NSLog(@"Opening URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
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
            
            
            [SVProgressHUD dismiss];
            [[self tableView] reloadData];
            
        }
        
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismissWithError:@"Network error"];
    }];
    [request startAsynchronous];
    
}

- (void) btnBrowserClicked:(id)sender{
    
    [self OpenBrowser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"Open Screen - Post Info"];
    [FlurryAPI logPageView];
    [self LoadNewData:[self postId]];
    
    self.tableView.rowHeight = 120.0f;
    
    

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
    if(postData != nil){
        if([comments count] != 0){
            return 2;
        }
        
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        if(postData != nil){
            return 1;
        }
    }
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    
    PostCell *cell = (PostCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = postCell;
        self.postCell = nil;
    }
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            cell.textLabel.text = [postData objectForKey:@"title"];
            cell.descriptionLabel.text = [[NSString alloc] initWithFormat:@"Posted %@ by %@", [postData objectForKey:@"postedAgo"], [postData objectForKey:@"postedBy"]];
        }
    
        
    }
    
    if(indexPath.section == 1){

        NSDictionary *comment = [comments objectAtIndex:[indexPath row]];
        NSString *stringHtml = [[NSString alloc] initWithFormat:@"%@", [comment objectForKey:@"comment"]];
        
        
        
        cell.textLabel.text = [stringHtml stringByConvertingHTMLToPlainText];
        cell.descriptionLabel.text = [[NSString alloc] initWithFormat:@"Posted %@ by %@", [comment objectForKey:@"postedAgo"], [comment objectForKey:@"postedBy"]];
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
        NSDictionary *comment = [comments objectAtIndex:indexPath.row];
        NSString *stringHtml = [[NSString alloc] initWithFormat:@"%@", [comment objectForKey:@"comment"]];
        
        FullCommentViewController *fullCommentView = [[FullCommentViewController alloc] init];
        fullCommentView.commentString = [stringHtml stringByConvertingHTMLToPlainText];
        
        
        fullCommentView.descriptionString = [[NSString alloc] initWithFormat:@"Posted %@ by %@", [comment objectForKey:@"postedAgo"], [comment objectForKey:@"postedBy"]];
        
        [self.navigationController pushViewController:fullCommentView animated:YES];
        //[stringHtml release];
        [fullCommentView release];
    }
}

@end
