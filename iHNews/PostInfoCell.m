//
//  PostInfoCell.m
//  HNews
//
//  Created by Guilherme Juraszek on 14/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "PostInfoCell.h"

@implementation PostInfoCell
@synthesize textLabel;
@synthesize detailLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
