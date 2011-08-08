//
//  PostInfoViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 07/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCell.h"
#import "FlurryAPI.h"

@class PostCell;
@interface PostInfoViewController : UITableViewController{
    UIView *loadingPanel;
    UIView *loadedPanel;
    NSDictionary *postData;
    NSArray *comments;
    NSNumber *postId;
    PostCell *postCell;
    
}

@property (nonatomic, retain) IBOutlet PostCell *postCell;
@property (nonatomic, retain) NSNumber *postId;
@property (nonatomic, retain) IBOutlet UIView *loadedPanel;
@property (nonatomic, retain) IBOutlet UIView *loadingPanel;

@end
