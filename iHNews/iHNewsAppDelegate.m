//
//  iHNewsAppDelegate.m
//  iHNews
//
//  Created by Guilherme Juraszek on 05/08/11.
//  Copyright 2011 Guilherme Juraszek. All rights reserved.
//

#import "iHNewsAppDelegate.h"
#import "NewsViewController.h"
#import "NewPostsViewController.h"
#import "NewCommentsViewController.h"
#import "FlurryAPI.h"

@implementation iHNewsAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FlurryAPI startSession:@"2ZYHIXFWEI5ZQE2EJMP2"];
    
    self.window.rootViewController = self.tabBarController;
    
    UINavigationController *navConHot = [[UINavigationController alloc] init];
    
    NewsViewController *hotPostsViewController = [[NewsViewController alloc] init];
    hotPostsViewController.title = @"Hot Posts";
    navConHot.tabBarItem.image = [UIImage imageNamed:@"fire.png"];
    [navConHot pushViewController:hotPostsViewController animated:NO];
    [hotPostsViewController release];
    
    
    UINavigationController *navConPosts = [[UINavigationController alloc] init];
    NewPostsViewController *newPosts = [[NewPostsViewController alloc] init];
    newPosts.title = @"New Posts";
    navConPosts.tabBarItem.image = [UIImage imageNamed:@"newspaper.png"];
    [navConPosts pushViewController:newPosts animated:NO];
    [newPosts release];
    
    
    UINavigationController *navConComments = [[UINavigationController alloc] init];
    NewCommentsViewController *commentsViewController = [[NewCommentsViewController alloc] init];
    navConComments.tabBarItem.image = [UIImage imageNamed:@"comments.png"];
    commentsViewController.title = @"Comments";
    [navConComments pushViewController:commentsViewController animated:NO];
    [commentsViewController release];
    
    
    NSArray *viewsController = [[NSArray alloc] initWithObjects:navConHot, navConPosts, navConComments,nil];
    [navConHot release];
    [navConPosts release];
    [navConComments release];
    
    [self.tabBarController setViewControllers:viewsController];
    [viewsController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
