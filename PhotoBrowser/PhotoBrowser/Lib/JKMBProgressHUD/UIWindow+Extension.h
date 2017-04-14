//
//  UIWindow+FCExtension.h
//  JKTest
//
//  Created by 蒋鹏 on 16/11/24.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)



/**
 取KeyWindow

 @return keyWindow
 */
+ (UIWindow *)KeyWindow;


/**
 取当前显示的控制器

 @return 当前显示的控制器
 */
+ (UIViewController *)currentViewController;



/**
 注销第一响应者
 */
+ (void)hidesKeyBoard;
@end
