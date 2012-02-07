//
//  NewPostsViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCell.h"
#import "FlurryAPI.h"
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "PostDownloader.h"

@class PostCell;
@interface NewPostsViewController : UITableViewController<NSFetchedResultsControllerDelegate, MBProgressHUDDelegate>{
@private
    //NSArray *_dataNews;
    PostCell *postCell;
    PostDownloader *postDownloader;
    MBProgressHUD *HUD;
}

//@property (retain) NSArray *_dataNews;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet PostCell *postCell;


@end
