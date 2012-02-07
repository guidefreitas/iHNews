//
//  PostDao.h
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"

@interface PostDao : NSObject
{
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)initWithManagedContext:(NSManagedObjectContext *)context;
- (Post *) FindById:(NSNumber *)postId;
@end
