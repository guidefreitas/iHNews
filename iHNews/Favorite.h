//
//  Favorite.h
//  HNews
//
//  Created by Guilherme Juraszek on 14/08/11.
//  Copyright (c) 2011 Guilherme Juraszek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Favorite : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Post *post;

@end
