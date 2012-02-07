//
//  SettingsViewController.h
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SettingsViewController : UIViewController

-(IBAction)clearCache:(id)sender;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
