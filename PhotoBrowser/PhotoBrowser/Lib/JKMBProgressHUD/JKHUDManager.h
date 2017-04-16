//
//  JKHUDManager.h
//  E顿饭
//
//  Created by 蒋鹏 on 16/12/14.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+GCDDelayTask.h"

@interface JKHUDManager : NSObject
+ (instancetype)shared;


/**
 【在当前控制器的View上】显示主标题和菊花

 @param text 内容
 */
- (void)showAnimatedHUDWithTitle:(NSString *)text;



/**
 显示主标题和菊花

 @param text 内容
 @param view view
 */
- (void)showAnimatedHUDInView:(UIView *)view
                        title:(NSString *)text;


/**
 【在当前控制器的View上】显示副标题文字

 @param text 内容
 */
- (void)showHUDWithDetail:(NSString *)text;



/**
 显示副标题文字

 @param text 内容
 @param view view
 */
- (void)showHUDInView:(UIView *)view
               detail:(NSString *)text;


/**
 显示副标题文字

 @param text 副标题
 @param view view
 @param dismissAction 消失事件
 */
- (void)showHUDInView:(UIView *)view
               detail:(NSString *)text
        dismissAction:(void (^)(void))dismissAction;


/**
 更新文字

 @param text 内容
 */
- (void)updateHUDWithText:(NSString *)text;


/**
 动态隐藏
 */
- (void)hideHUDAnimated;



/**
 隐藏

 @param animation 是否动画
 */
- (void)hideHUDAnimated:(BOOL)animation;
@end


static inline JKHUDManager * HUDManager(){
    return [JKHUDManager shared];
}
