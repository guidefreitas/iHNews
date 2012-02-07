//
//  PostDownloader.h
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"
#import "Comment.h"
#import "MBProgressHUD.h"
#import "PostDao.h"

@interface PostDownloader : NSObject{
    //PostDao *postDao;
}

@property (retain) MBProgressHUD *hud;
//@property (retain) PostDao *postDao;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
- (id)initWithManagedContext:(NSManagedObjectContext *)context;

-(void) UpdateHotPosts;
-(void) UpdateNewPosts;
-(void) AddFavoritePost:(NSNumber *) postId;
-(void) RemoveFavoritePost:(NSNumber *) postId;
-(void) UpdateFavorites;
//-(Post *) PostById:(NSNumber *) postId;

@end
