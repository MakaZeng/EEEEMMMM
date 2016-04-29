//
//  AppDelegate.h
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/8.
//  Copyright © 2016年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShareInstance.h"

#define UMENG_KEY @"571dd6c167e58e9798000f8a"
#define BUGLY_ID @"900027818"
#define BUGLY_KEY @"Q5qWo72iQSJP0BVx"

#define QQ_APP_ID @"1105283751"
#define QQ_APP_KEY @"FaO0qmyPPBUF0bb1"

#define WX_APP_ID @"wx3259b2aab2fcdaba"
#define WX_APP_Sec @"1f728f1147a33ca7010a518a6ad70a65"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

