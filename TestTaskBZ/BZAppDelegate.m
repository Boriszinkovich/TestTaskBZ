//
//  AppDelegate.m
//  TestTaskBZ
//
//  Created by Boris Zinkovich on 27.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZAppDelegate.h"
#import "BZMainViewController.h"
#import <MagicalRecord/MagicalRecord.h>
@interface BZAppDelegate ()

@end

@implementation BZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // подключение базы данных с готовыми категориями и вопросами
    NSURL *defaultStorePath = [NSPersistentStore MR_defaultLocalStoreUrl];
    defaultStorePath = [[defaultStorePath URLByDeletingLastPathComponent] URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[defaultStorePath path]]) {
        NSURL *seedPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TestTaskBZ" ofType:@"sqlite"]];
        NSLog(@"Core data store does not yet exist at: %@. Attempting to copy from seed db %@.", [defaultStorePath path], [seedPath path]);
        [self createPathToStoreFileIfNeccessary:defaultStorePath];
        
        NSError* err = nil;
        if (![fileManager copyItemAtURL:seedPath toURL:defaultStorePath error:&err]) {
            NSLog(@"Could not copy seed data. error: %@", err);
        }
    }
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"TestTaskBZ.sqlite"];
    // создание корневого вью контроллера
   BZMainViewController* rootController = [[BZMainViewController alloc] init];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    self.window.rootViewController = navigation;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void) createPathToStoreFileIfNeccessary:(NSURL *)urlForStore {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
}



@end
