//
//  UIViewController+TopViewController.m
//  Tella
//
//  Created by Maxwell on 2016/10/24.
//  Copyright © 2016年 Saunter Studio. All rights reserved.
//

#import "UIViewController+TopViewController.h"
#import "AppDelegate.h"

@implementation UIViewController (TopViewController)

+ (UIViewController*)topViewController {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = [appdelegate.window rootViewController];
    return [rootViewController topVisibleViewController];
}

- (UIViewController*)topVisibleViewController {
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)self;
        return [tabBarController.selectedViewController topVisibleViewController];
    } else if ([self isKindOfClass:[UISplitViewController class]]){
        UISplitViewController* svc = (UISplitViewController*)self;
        if (svc.viewControllers.count > 0){
            return [svc.viewControllers.lastObject topVisibleViewController];
        }else {
            return self;
        }
    }
    else if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)self;
        return [navigationController.visibleViewController topVisibleViewController];
    }
    else if (self.presentedViewController)
    {
        return [self.presentedViewController topVisibleViewController];
    }
    else if (self.childViewControllers.count > 0)
    {
        return [self.childViewControllers.lastObject topVisibleViewController];
    }
    
    return self;
}

@end
