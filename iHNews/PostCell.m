//
//  PostCell.m
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

@synthesize textLabel;
@synthesize descriptionLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *backgroundImage = [UIImage imageNamed:@"cellbackground.png"];
        self.backgroundView = backgroundImage;
        [backgroundImage release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
