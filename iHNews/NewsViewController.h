//
//  NewsViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 05/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostCell;
@interface NewsViewController : UITableViewController{
@private
    NSArray *_dataNews;
    PostCell *postCell;
}

@property (nonatomic, retain) IBOutlet PostCell *postCell;
@property (retain) NSArray *_dataNews;

@end
