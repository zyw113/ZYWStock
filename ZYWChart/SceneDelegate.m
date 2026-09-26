//
//  SceneDelegate.m
//  ZYWChart
//
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "FHHFPSIndicator.h"
#import "BaseNavigationController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *Controller = [[ViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:Controller];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
#if defined(DEBUG) || defined(_DEBUG)
    
    [[FHHFPSIndicator sharedFPSIndicator] show];
    
#endif
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
}

@end
