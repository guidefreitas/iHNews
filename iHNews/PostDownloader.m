//
//  PostDownloader.m
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "PostDownloader.h"
#import "ASIHTTPRequest.h"
#include "JSON.h"
#import "FlurryAPI.h"
#import "CommentDao.h"

@implementation PostDownloader

@synthesize managedObjectContext = __managedObjectContext;
@synthesize hud;
//@synthesize postDao;

- (id)initWithManagedContext:(NSManagedObjectContext *)context{
    self = [super init];
    if(self)
    {
        //self.postDao = [[postDao alloc] initWithManagedContext:context];
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


- (Post *) FindPostById:(NSNumber *)postId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Post" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", postId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    NSArray *array = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([array count] > 0){
        return (Post *) [array objectAtIndex:0];
    }
    
    return NULL;
}

-(void) SavePostsInDatabase:(NSDictionary *) obj withType:(NSNumber *) postType{
    
    NSNumber *postId = [[obj objectForKey:@"id"] retain];
    //hud.detailsLabelText  = [NSString stringWithFormat:@"Downloading post %@",postId];
    Post *post = [self FindPostById:postId];
    if(!post){
        post = [[NSEntityDescription
                 insertNewObjectForEntityForName:@"Post" 
                 inManagedObjectContext:__managedObjectContext] retain];
        
        
        post.id = postId;
    }
    
    if([obj objectForKey:@"points"] !=  [NSNull null])
        post.points = [obj objectForKey:@"points"];
    
    if([obj objectForKey:@"postedBy"] !=  [NSNull null])
    post.user = [obj objectForKey:@"postedBy"];
    
    if([obj objectForKey:@"postedAgo"] !=  [NSNull null])
        post.postedAgo = [obj objectForKey:@"postedAgo"];
    
    if([obj objectForKey:@"url"] !=  [NSNull null])
        post.url = [obj objectForKey:@"url"];
    
    if([obj objectForKey:@"title"] !=  [NSNull null])
        post.title = [obj objectForKey:@"title"];
    
    post.postType = postType;
    
    
    post.date = [[NSDate alloc] init];
    
    if(!post.page || [post.page length] == 0){
        NSLog(@"Downloading Page for post: %@", postId);
        NSURL *url = [NSURL URLWithString:post.url];
        post.page = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error: NULL];
    }
    
    NSNumber *commentsCountSite = [obj objectForKey:@"commentCount"];
    NSNumber *commentsCountDb = post.commentsCount;
    NSLog([NSString stringWithFormat:@"Post %@, dbComments: %@ , siteComments: %@", postId, commentsCountDb, commentsCountSite]);
    if(![commentsCountSite isEqualToNumber:commentsCountDb]){
        
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://api.ihackernews.com/post/%@", postId];
        NSLog(@"Opening URL: %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        [urlString release];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setTimeOutSeconds:10];
        [request setAllowCompressedResponse:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startSynchronous];
        NSError *httpError = [request error];
        
        if(httpError){
            NSLog(@"Erro ao baixar post %@", postId);
            return;
        }
        
        if (!httpError) {
            NSString *responseString = [request responseString];
            NSDictionary *postData = [responseString JSONValue];
            
            if(postData){
                NSMutableArray *comments = [[NSMutableArray alloc] init];
                
                NSArray *firstlevelComments = [postData objectForKey:@"comments"];
                [comments addObjectsFromArray:firstlevelComments];
                
                for(NSDictionary *comment in firstlevelComments){
                    NSArray *secondLevelComments = [comment objectForKey:@"children"];
                    
                    if(secondLevelComments){
                        [comments addObjectsFromArray:secondLevelComments];
                        
                        for(NSDictionary *comment in secondLevelComments){
                            NSArray *thirthLevelComments = [comment objectForKey:@"children"];
                            
                            if(thirthLevelComments){
                                [comments addObjectsFromArray:thirthLevelComments];
 
                            }
                        }
                        
                    }
                }

                
                CommentDao *commentDao = [[CommentDao alloc] initWithManagedContext:self.managedObjectContext];
                
                for(NSDictionary *obj in comments){
                    NSNumber *commentId = [obj objectForKey:@"id"];
                    
                    Comment *comment = [commentDao FindById:commentId];
                    
                    if(!comment){
                    
                        comment = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Comment" 
                                        inManagedObjectContext:__managedObjectContext];
                    }
                    if([obj objectForKey:@"id"] !=  [NSNull null])
                        comment.commentId = [obj objectForKey:@"id"];
                    
                    if([obj objectForKey:@"comment"] !=  [NSNull null])
                        comment.content = [obj objectForKey:@"comment"];
                    
                    if([obj objectForKey:@"postedBy"] !=  [NSNull null])
                        comment.user = [obj objectForKey:@"postedBy"];
                    
                    if([obj objectForKey:@"points"] !=  [NSNull null])
                        comment.points = [obj objectForKey:@"points"];
                    
                    if([obj objectForKey:@"postedAgo"] !=  [NSNull null])
                        comment.postedAgo = [obj objectForKey:@"postedAgo"];
                    comment.postId = postId;
                    
                    
                    NSLog([NSString stringWithFormat:@"Adicionando Comentario ao post %@",postId]);
                    
                   
                }
                
                if([obj objectForKey:@"commentCount"] !=  [NSNull null]){
                    NSNumber *cCount = [obj objectForKey:@"commentCount"];
                    post.commentsCount = cCount;
                }
                
            }
            
        }
        
        
    }
    
    NSError *error;
    if (![__managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(void) UpdatePostFromUrlString:(NSString *)urlString withType:(NSNumber *) postType{
    NSLog(@"Downloading posts");
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *data = [responseString JSONValue];
        if(!data){
            [FlurryAPI logEvent:@"Screen - Hot Posts - Network Error (invalid data)"];
            hud.mode = MBProgressHUDModeDeterminate;
            hud.labelText = @"Network error";
            hud.detailsLabelText = @"";
            [hud hide:YES afterDelay:1];
        }else{
            NSArray *dataDownloaded = [data objectForKey:@"items"];
            
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                hud.mode = MBProgressHUDModeDeterminate;
                hud.labelText = @"Caching data";
                NSNumber *totalItens = [NSNumber numberWithInteger:[dataDownloaded count]];
                NSNumber *count = [NSNumber numberWithInt:0];
                
                for(NSDictionary *obj in dataDownloaded){
                    float progress = [count floatValue] / [totalItens floatValue]; 
                    hud.progress =  progress;
                    hud.detailsLabelText  = [NSString stringWithFormat:@"%@ of %@",count, totalItens];
                    NSLog([NSString stringWithFormat:@"Downloading post %@", [obj objectForKey:@"id"]]);
                    [self SavePostsInDatabase:obj  withType:postType];
                    count  = [NSNumber numberWithInt:[count intValue] + 1];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    
                });
            }); 
        }
    }]; 
    [request setFailedBlock:^{
        [FlurryAPI logEvent:@"Screen - Hot Posts - Network Error (connection error)"];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"Offline mode";
        hud.detailsLabelText = @"";
        [hud hide:YES afterDelay:1];
    }];
    [request startAsynchronous];
}

-(void) UpdateHotPosts{
    [self UpdatePostFromUrlString:@"http://api.ihackernews.com/page" withType:[[NSNumber numberWithInt:0] retain]];
}

-(void) UpdateNewPosts{
    [self UpdatePostFromUrlString:@"http://api.ihackernews.com/new"  withType:[[NSNumber numberWithInt:1] retain]];
}

-(void) AddFavoritePost:(NSNumber *) postId{
    [postId retain];
    NSLog(@"Adding post %@ to favorites", postId);
    PostDao *postDao = [[PostDao alloc] initWithManagedContext:self.managedObjectContext];
    Post *post = [postDao FindById:postId];
    post.postType = [NSNumber numberWithInt:2];
    
    NSError *error;
    if (![__managedObjectContext save:&error]) {
        NSLog(@"Erro ao salvar post aos favoritos: %@", [error localizedDescription]);
    }

    [post release];
    [postDao release];
    
}

-(void) RemoveFavoritePost:(NSNumber *) postId{
    [postId retain];
    PostDao *postDao = [[PostDao alloc] initWithManagedContext:self.managedObjectContext];
    Post *post = [postDao FindById:postId];
    post.postType = [NSNumber numberWithInt:1];
    [__managedObjectContext save:NULL];
}

-(void) UpdateFavorites{
    NSLog(@"Updating Favorite Posts");
}

@end
