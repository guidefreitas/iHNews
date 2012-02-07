//
//  Comment.h
//  HNews
//
//  Created by Guilherme Juraszek on 14/08/11.
//  Copyright (c) 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * postedAgo;
@property (nonatomic, retain) NSNumber * postId;
@property (nonatomic, retain) NSString * user;

@end
