//
//  CommentDao.m
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "CommentDao.h"

@implementation CommentDao
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

- (NSArray *) FindByPostId:(NSNumber *)postId{
    NSLog([NSString stringWithFormat:@"Buscando comentarios para post %@",postId]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Comment" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %@", postId];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil; 
    NSArray *array = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    
    //NSLog([NSString stringWithFormat:@"Total comentarios: %@",[array count]]);

    return array;
}

- (Comment *) FindById:(NSNumber *)commentId{
    NSLog([NSString stringWithFormat:@"Buscando comentario com id %@",commentId]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Comment" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId == %@", commentId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    NSArray *array = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog([NSString stringWithFormat:@"Total comentarios: %@",[array count]]);
    [fetchRequest release];
    
    if([array count] > 0){
        return (Comment *) [array objectAtIndex:0];
    }
    return NULL;
}

@end
