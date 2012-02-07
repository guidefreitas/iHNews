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
#import "CommentDao.h"

@implementation NewPostsViewController

@synthesize postCell;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

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

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Post" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"date" ascending:NO];
    
    
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postType == 1"];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:30];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:__managedObjectContext sectionNameKeyPath:nil 
                                                   cacheName:@"NewPostsCache"];
    self.fetchedResultsController = theFetchedResultsController;
    __fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return __fetchedResultsController;    
    
}

-(void)RefreshNewPosts{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    postDownloader.hud = HUD;
    [postDownloader UpdateNewPosts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"Open Screen - New Posts"];
    [FlurryAPI logPageView];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];
    
    self.navigationItem.leftBarButtonItem = refreshButton;
    [refreshButton release];
    self.tableView.rowHeight = 100.0f;
    
    postDownloader = [[PostDownloader alloc] initWithManagedContext:self.managedObjectContext];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[__fetchedResultsController sections] objectAtIndex:0];
	if([sectionInfo numberOfObjects] == 0){
        [self RefreshNewPosts];
    }
    
    
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

    id <NSFetchedResultsSectionInfo> sectionInfo = [[__fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (void)configureCell:(PostCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Post *post = [__fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = post.title;
    cell.descriptionLabel.text =  [[[NSString alloc] initWithFormat:@"%@ points and %@ comments", post.points ,post.commentsCount] autorelease];
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        Post *post = [__fetchedResultsController objectAtIndexPath:indexPath];
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.textLabel.text = post.title;
            cell.descriptionLabel.text =  [[[NSString alloc] initWithFormat:@"%@ points and %@ comments", post.points ,post.commentsCount] autorelease];
        });
    });
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    
    PostCell *cell = (PostCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = postCell;
        self.postCell = nil;
    }
    
    [self configureCell:cell atIndexPath:indexPath];

    
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
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
    CommentDao *commentDao = [[CommentDao alloc] init];
    commentDao.managedObjectContext = self.managedObjectContext;
    
    
    PostInfoViewController *postInfo = [[PostInfoViewController alloc] init];
    Post *postSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSArray *comments = [commentDao FindByPostId:postSelected.id];
    postInfo.managedObjectContext = self.managedObjectContext;
    postInfo.post = postSelected;
    postInfo.comments = comments;
    [self.navigationController pushViewController:postInfo animated:YES];
    [postInfo release];
    [postSelected release];
}

@end
