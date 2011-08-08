//
//  PostCell.h
//  iHNews
//
//  Created by Guilherme Juraszek on 06/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell{
    UILabel *textLabel;
    UILabel *descriptionLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

@end
