//
//  AppDelegate.m
//  LeanCloud
//
//  Created by yuebin on 16/8/7.
//  Copyright © 2016年 yuebin. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialPageViewController.h"
#import "MainPageViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AVOSCloud setApplicationId:@"vE04MgSzxzKVOV2H47us573e-gzGzoHsz" clientKey:@"IAjmsuyvsCw7BCz8noLNPiI2"];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];//用来统计应用的打开情况
    
//#warning 打开日志，发布时关闭
//    [AVOSCloud setAllLogsEnabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setInitialPage];
    
    NSLog(@"%@", NSHomeDirectory());
    return YES;
}

#pragma mark - 欢迎页
- (void)setInitialPage {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstMark = [[userDefaults objectForKey:@"firstMark"]boolValue];
    if (firstMark) {
        //说明已经打开过了，直接进入mainPage
//        [self setMainVC];
        self.window.rootViewController = [[MainPageViewController alloc]init];
    }else {
        //是首次打开,进入到欢迎页
        [userDefaults setObject:@(YES) forKey:@"firstMark"];
        self.window.rootViewController = [[InitialPageViewController alloc]init];
    }
}

//- (void)setMainVC {
//
//    MainPageViewController *mainVC = [[MainPageViewController alloc]init];
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mainVC];
//    LeftDrawerViewController *leftDrawer = [[LeftDrawerViewController alloc]init];
//    
//    MMDrawerController *mm = [[MMDrawerController alloc]initWithCenterViewController:nvc leftDrawerViewController:leftDrawer];
//    mm.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    mm.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    mm.maximumLeftDrawerWidth = 4*KSC_W/5;
//    
//    self.window.rootViewController = mm;
//}

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
}

@end
