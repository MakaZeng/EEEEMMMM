//
//  AppDelegate.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <COSTouchVisualizerWindow.h>
#import "CollectionViewController.h"
#import "IndexViewController.h"
#import "BrowserViewController.h"

@interface AppDelegate ()<COSTouchVisualizerWindowDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [WXApi handleOpenURL:url delegate:nil];
    if (!result) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [WXApi handleOpenURL:url delegate:nil];
    if (!result) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UMSocialData setAppKey:UMENG_KEY];
    [Bugly startWithAppId:BUGLY_ID];
    
    {
        TencentOAuth* oauth = [[TencentOAuth alloc]initWithAppId:QQ_APP_ID andDelegate:nil];
        oauth = nil;
    }
    
    {
        [WXApi registerApp:WX_APP_ID];
    }
    
    {
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UITabBarController* tabbar = [[UITabBarController alloc]init];
        NSMutableArray* mArray = [NSMutableArray array];
        UIViewController* vc = nil;
        UINavigationController* navi = nil;
        {
            vc = [[CollectionViewController alloc]init];
            navi = [[UINavigationController alloc]initWithRootViewController:vc];
             navi.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Collection", @"Emoticon") image:ImageNamed(NSLocalizedString(@"like_selected", @"like_selected")) tag:1];
            [mArray addObject:navi];
        }
        {
            vc = [[IndexViewController alloc]init];
            navi = [[UINavigationController alloc]initWithRootViewController:vc];
             navi.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Emoticon", @"Emoticon") image:ImageNamed(NSLocalizedString(@"tabbar_emotions", @"like_selected")) tag:1];
            [mArray addObject:navi];
        }
        {
            vc = [[BrowserViewController alloc]init];
            navi = [[UINavigationController alloc]initWithRootViewController:vc];
            navi.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Browser", @"Emoticon") image:ImageNamed(NSLocalizedString(@"tabbar_browser", @"like_selected")) tag:1];
            [mArray addObject:navi];
        }
        tabbar.viewControllers = mArray;
        self.window.rootViewController = tabbar;
        [self.window makeKeyAndVisible];
    }
    
    
    {
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UITabBar appearance] setTranslucent:NO];
        [[UIToolbar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        [[UINavigationBar appearance] setTintColor:BASE_Tint_COLOR];
        [[UINavigationBar appearance] setBarTintColor:BASE_BACK_COLOR];
        [[UITabBar appearance] setTintColor:BASE_Tint_COLOR];
        [[UITabBar appearance] setBarTintColor:BASE_BACK_COLOR];
        [[UIToolbar appearance] setTintColor:BASE_Tint_COLOR];
        [[UIToolbar appearance] setBarTintColor:BASE_BACK_COLOR];
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          BASE_Tint_COLOR,
          NSForegroundColorAttributeName,
          BASE_Tint_COLOR,
          NSForegroundColorAttributeName,
          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
          NSForegroundColorAttributeName,
          [UIFont fontWithName:@"Arial-Bold" size:0.0],
          NSFontAttributeName,
          nil]];
    }
    
    return YES;
}

//- (COSTouchVisualizerWindow *)window {
//    static COSTouchVisualizerWindow *visWindow = nil;
//    if (!visWindow) visWindow = [[COSTouchVisualizerWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Add these lines after the windows is initialized
//    // Touch Color
//    visWindow.touchVisualizerWindowDelegate = self;
//    [visWindow setFillColor:[UIColor whiteColor]];
//    [visWindow setStrokeColor:[UIColor lightGrayColor]];
//    [visWindow setTouchAlpha:0.2];
//    // Ripple Color
//    [visWindow setRippleFillColor:[UIColor yellowColor]];
//    [visWindow setRippleStrokeColor:[UIColor lightGrayColor]];
//    [visWindow setRippleAlpha:0.1];
//    return visWindow;
//}

- (BOOL)touchVisualizerWindowShouldAlwaysShowFingertip:(COSTouchVisualizerWindow *)window {
    return YES;  // Return YES to make the fingertip always display even if there's no any mirrored screen.
    // Return NO or don't implement this method if you want to keep the fingertip display only when
    // the device is connected to a mirrored screen.
}

- (BOOL)touchVisualizerWindowShouldShowFingertip:(COSTouchVisualizerWindow *)window {
    return YES;  // Return YES or don't implement this method to make this window show fingertip when necessary.
    // Return NO to make this window not to show fingertip.
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "maka.BiaoQingBao" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BiaoQingBao" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BiaoQingBao.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
