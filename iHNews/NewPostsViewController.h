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

@class PostCell;
@interface NewPostsViewController : UITableViewController{
@private
    NSArray *_dataNews;
    PostCell *postCell;
}

@property (retain) NSArray *_dataNews;
@property (nonatomic, retain) IBOutlet PostCell *postCell;


@end
