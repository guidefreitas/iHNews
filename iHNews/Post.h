//
//  Post.h
//  HNews
//
//  Created by Guilherme Juraszek on 14/08/11.
//  Copyright (c) 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorite;

@interface Post : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * page;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * postedAgo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * postType;
@property (nonatomic, retain) Favorite *favorites;

@end
