//
//  UIWindow+FCExtension.m
//  JKTest
//
//  Created by 蒋鹏 on 16/11/24.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)

+ (UIWindow *)KeyWindow{
    NSArray * windows = [UIApplication sharedApplication].windows;
    for (id window in windows) {
        if ([window isKindOfClass:[UIWindow class]]) {
            return (UIWindow *)window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}


+ (UIViewController *)currentViewController{
    UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

// 遍历正在显示（最上层）的控制器
+ (UIViewController *)findBestViewController:(UIViewController *)viewController{
    if (viewController.presentedViewController) {
        return [self findBestViewController:viewController.presentedViewController];
        
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController * masterViewController = (UISplitViewController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.viewControllers.lastObject];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * masterViewController = (UINavigationController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.topViewController];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * masterViewController = (UITabBarController *) viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.selectedViewController];
        else
            return viewController;
    } else {
        return viewController;
    }
}

+ (void)hidesKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
