//
//  FavoriteViewController.h
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FlurryAPI.h"
#import "PostCell.h"
#import "Post.h"
#import "PostDownloader.h"
#import "Comment.h"
#import "CommentDao.h"
#import "PostInfoViewController.h"

@interface FavoriteViewController : UITableViewController<NSFetchedResultsControllerDelegate>{
    PostCell *postCell;
    PostDownloader *postDownloader;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet PostCell *postCell;
@end
