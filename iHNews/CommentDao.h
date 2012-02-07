//
//  CommentDao.h
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Comment.h"

@interface CommentDao : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)initWithManagedContext:(NSManagedObjectContext *)context;
- (Comment *) FindById:(NSNumber *)commentId;
- (NSArray *) FindByPostId:(NSNumber *)postId;

@end
