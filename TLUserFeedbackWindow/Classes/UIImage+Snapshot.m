//
//  UIImage+Snapshot.m
//  onepage
//
//  Created by Maxwell on 15/11/16.
//  Copyright © 2015年 Saunter Studio. All rights reserved.
//

#import "UIImage+Snapshot.h"
#import <objc/runtime.h>
#import "UIViewController+TopViewController.h"

@implementation UIImage (Snapshot)

+ (UIImage *)imageSnapshot {

    UIViewController *topViewController = [UIViewController topViewController];
    UIGraphicsBeginImageContextWithOptions(topViewController.view.bounds.size, YES, 2.0f);
    [topViewController.view drawViewHierarchyInRect:topViewController.view.bounds afterScreenUpdates:YES];
    UIImage *finalImage                 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

@end
