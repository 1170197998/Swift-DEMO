//
//  JKHUDManager.m
//  E顿饭
//
//  Created by 蒋鹏 on 16/12/14.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JKHUDManager.h"
#import "MBProgressHUD.h"
#import "UIWindow+Extension.h"
#import "NSObject+GCDDelayTask.h"

@interface JKHUDManager ()

@property (nonatomic, strong)MBProgressHUD * HUD;


@end



@implementation JKHUDManager
+ (instancetype)shared{
    static JKHUDManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JKHUDManager alloc]init];
    });
    return manager;
}


- (void)showAnimatedHUDWithTitle:(NSString *)text{
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [UIWindow.currentViewController.view addSubview:self.HUD];
    self.HUD.labelText = text;
    self.HUD.detailsLabelText = nil;
    [self.HUD show:YES];
}

- (void)showAnimatedHUDInView:(UIView *)view
                        title:(NSString *)text{
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [view addSubview:self.HUD];
    self.HUD.labelText = text;
    self.HUD.detailsLabelText = nil;
    [self.HUD show:YES];
}

- (void)updateHUDWithText:(NSString *)text{
    if (self.HUD.labelText) {
        self.HUD.labelText = text;
    }else if (self.HUD.detailsLabelText){
        self.HUD.detailsLabelText = text;
    }
}


- (void)showHUDWithDetail:(NSString *)text{
    self.HUD.mode = MBProgressHUDModeText;
    [UIWindow.currentViewController.view addSubview:self.HUD];
    self.HUD.margin = 10.f;
    self.HUD.yOffset = 15.f;
    self.HUD.detailsLabelText = text;
    self.HUD.labelText = nil;
    [self.HUD show:YES];
    [self jk_excuteDelayTask:1.5 inMainQueue:^{
        [self hideHUDAnimated];
    }];
}


- (void)showHUDInView:(UIView *)view
               detail:(NSString *)text {
    self.HUD.mode = MBProgressHUDModeText;
    [view addSubview:self.HUD];
    self.HUD.detailsLabelText = text;
    self.HUD.labelText = nil;
    [self.HUD show:YES];
    [self jk_excuteDelayTask:1.5 inMainQueue:^{
        [self hideHUDAnimated:NO];
    }];
}

- (void)showHUDInView:(UIView *)view
               detail:(NSString *)text
        dismissAction:(void (^)(void))dismissAction {
    
    self.HUD.mode = MBProgressHUDModeText;
    [view addSubview:self.HUD];
    self.HUD.detailsLabelText = text;
    self.HUD.labelText = nil;
    [self.HUD show:YES];
    [self jk_excuteDelayTask:1.5 inMainQueue:^{
        [self hideHUDAnimated:NO];
        if (dismissAction) {
            dismissAction();
        }
    }];
}


#pragma mark - 隐藏
- (void)hideHUDAnimated{
    [self hideHUDAnimated:YES];
}

- (void)hideHUDAnimated:(BOOL)animation{
    if (self.HUD.isHidden == NO) {
        [self.HUD hide:animation];
    }
}


#pragma mark - 懒加载
- (MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithWindow:[UIWindow KeyWindow]];
        _HUD.removeFromSuperViewOnHide = YES;
        _HUD.userInteractionEnabled = YES;
        _HUD.detailsLabelFont = [UIFont systemFontOfSize:19];
        _HUD.labelFont = [UIFont systemFontOfSize:19];
    }return _HUD;
}

@end
