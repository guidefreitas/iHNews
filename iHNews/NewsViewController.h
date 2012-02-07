//
//  NewsViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 05/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "PostDownloader.h"

@class PostCell;
@interface NewsViewController : UITableViewController<NSFetchedResultsControllerDelegate, MBProgressHUDDelegate>{
@private
    //NSArray *_dataNews;
    PostCell *postCell;
    MBProgressHUD *HUD;
    PostDownloader *postDownloader;
}

@property (nonatomic, retain) IBOutlet PostCell *postCell;
//@property (retain) NSArray *_dataNews;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (id) initWithManagedContext:(NSManagedObjectContext *)context;


@end
