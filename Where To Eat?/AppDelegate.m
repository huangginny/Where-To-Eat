//
//  AppDelegate.m
//  Where To Eat?
//
//  Created by Ginny on 9/6/14.
//  Copyright (c) 2014 Ginny Huang. All rights reserved.
//

#import "AppDelegate.h"
#import "RestaurantStore.h"
#import "History.h"
#import "DiceTableViewController.h"
#import "CategoriesTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIStoryboard *storyboard = [UIStoryboard
                                        storyboardWithName:@"DiceStoryboard"
                                        bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"diceController"];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    {
        BOOL success1 = [[RestaurantStore sharedStore] saveChanges];
        if (success1) {
            NSLog(@"Saved all of the Restaurants");
        }
        else {
            NSLog(@"Could not save any of the Restaurants");
        }
        BOOL success2 = [[History history] saveChanges];
        if (success2) {
            NSLog(@"Saved all of the Histories");
        }
        else {
            NSLog(@"Could not save any of the Histories");
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
