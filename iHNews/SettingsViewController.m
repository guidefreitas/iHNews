//
//  SettingsViewController.m
//  HNews
//
//  Created by Guilherme Juraszek on 13/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)clearCache:(id)sender{
    NSLog(@"Cleaning cache data");
    
    NSLog(@"Deleting comments");
    NSFetchRequest *fetchRequestComment = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityComment = [NSEntityDescription 
                                   entityForName:@"Comment" inManagedObjectContext:__managedObjectContext];
    [fetchRequestComment setEntity:entityComment];
    
    NSError *error = nil; 
    NSArray *comments = [__managedObjectContext executeFetchRequest:fetchRequestComment error:&error];
    //NSLog([NSString stringWithFormat:@"Total comentarios: %@",[array count]]);
    [fetchRequestComment release];
    
    for(NSManagedObject *obj in comments){
        [__managedObjectContext deleteObject:obj];
    }
    
    NSLog(@"Deleting posts");
    NSFetchRequest *fetchRequestPosts = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityPosts = [NSEntityDescription 
                                          entityForName:@"Post" inManagedObjectContext:__managedObjectContext];
    [fetchRequestPosts setEntity:entityPosts];
    
    NSError *errorPosts = nil; 
    NSArray *posts = [__managedObjectContext executeFetchRequest:fetchRequestPosts error:&errorPosts];
   
    
    
    for(NSManagedObject *obj in posts){
        [__managedObjectContext deleteObject:obj];
    }
    
    
    NSError *errorsave;
    if (![__managedObjectContext save:&errorsave]) {
        NSLog(@"Whoops, couldn't save: %@", [errorsave localizedDescription]);
    }
    
    

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
