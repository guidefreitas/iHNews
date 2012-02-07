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
#import "FavoriteViewController.h"
#import "SettingsViewController.h"
#import "FlurryAPI.h"
#import "PostDao.h"
@implementation iHNewsAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FlurryAPI startSession:@"2ZYHIXFWEI5ZQE2EJMP2"];
    
    self.window.rootViewController = self.tabBarController;
    
    UINavigationController *navConHot = [[UINavigationController alloc] init];
    
    NewsViewController *hotPostsViewController = [[NewsViewController alloc] initWithManagedContext:self.managedObjectContext];
    
    hotPostsViewController.title = @"Hot Posts";
    navConHot.tabBarItem.image = [UIImage imageNamed:@"fire.png"];
    [navConHot pushViewController:hotPostsViewController animated:NO];
    [hotPostsViewController release];
    
    
    UINavigationController *navConPosts = [[UINavigationController alloc] init];
    NewPostsViewController *newPosts = [[NewPostsViewController alloc] init];
    newPosts.managedObjectContext = self.managedObjectContext;
    newPosts.title = @"New Posts";
    navConPosts.tabBarItem.image = [UIImage imageNamed:@"newspaper.png"];
    [navConPosts pushViewController:newPosts animated:NO];
    [newPosts release];
    
    
    UINavigationController *navConComments = [[UINavigationController alloc] init];
    FavoriteViewController *favoritesViewController = [[FavoriteViewController alloc] init];
    favoritesViewController.managedObjectContext = self.managedObjectContext;
    navConComments.tabBarItem.image = [UIImage imageNamed:@"star.png"];
    favoritesViewController.title = @"Favorites";
    [navConComments pushViewController:favoritesViewController animated:NO];
    [favoritesViewController release];
    
    UINavigationController *navConSettings = [[UINavigationController alloc] init];
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.managedObjectContext = self.managedObjectContext;
    navConSettings.tabBarItem.image = [UIImage imageNamed:@"preferences.png"];
    settingsViewController.title = @"Settings";
    [navConSettings pushViewController:settingsViewController animated:NO];
    [settingsViewController release];
    
    
    NSArray *viewsController = [[NSArray alloc] initWithObjects:navConHot, navConPosts, navConComments,navConSettings, nil];
    [navConHot release];
    [navConPosts release];
    [navConComments release];
    [navConSettings release];
    
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
    NSLog(@"Entrando em background");
    NSLog(@"Salvando managedObjectContext");
    [self.managedObjectContext save:NULL];
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
    NSLog(@"Terminando aplicacao");
    NSLog(@"Salvando managedObjectContext");
    [self.managedObjectContext save:NULL];
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HNews" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HNews.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
