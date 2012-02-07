//
//  PostDao.m
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "PostDao.h"

@implementation PostDao
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithManagedContext:(NSManagedObjectContext *)context{
    self = [super init];
    if(self)
    {
        self.managedObjectContext = context;
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (Post *) FindById:(NSNumber *)postId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Post" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", postId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    NSArray *array = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    if([array count] > 0){
        return (Post *) [array objectAtIndex:0];
    }
    
    return NULL;
}

@end
