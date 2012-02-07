//
//  PostInfoCell.h
//  HNews
//
//  Created by Guilherme Juraszek on 14/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostInfoCell : UITableViewCell{
    UILabel *textLabel;
    UILabel *detailLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailLabel;
@end
