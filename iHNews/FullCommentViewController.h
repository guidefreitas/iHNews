//
//  FullCommentViewController.h
//  iHNews
//
//  Created by Guilherme Juraszek on 07/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAPI.h"

@interface FullCommentViewController : UIViewController{

    UITextView *comment;
    UILabel *descriptionLabel;
    NSString *commentString;
    NSString *descriptionString;
    
}

@property (retain) NSString *commentString;
@property (retain) NSString *descriptionString;
@property (nonatomic, retain) IBOutlet UITextView *comment;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

@end
