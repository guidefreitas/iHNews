//
//  PostInfoViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 07/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfoCell.h"
#import "FlurryAPI.h"
#import "PostDownloader.h"
#import "Post.h"
#import <CoreData/CoreData.h>

@class PostCell;
@interface PostInfoViewController : UITableViewController{
    UIView *loadingPanel;
    UIView *loadedPanel;
    Post *post;
    NSArray *comments;
    NSNumber *postId;
    PostInfoCell *postCell;
    
}

@property (retain) NSArray *comments;
@property (retain) Post *post;
@property (nonatomic, retain) IBOutlet PostInfoCell *postCell;
@property (nonatomic, retain) NSNumber *postId;
@property (nonatomic, retain) IBOutlet UIView *loadedPanel;
@property (nonatomic, retain) IBOutlet UIView *loadingPanel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
