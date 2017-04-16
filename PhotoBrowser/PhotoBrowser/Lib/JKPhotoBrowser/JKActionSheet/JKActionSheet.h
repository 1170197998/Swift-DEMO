//
//  JKActionSheet.h
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface JKActionSheet : UIView

typedef void(^JKActionSheetHandle)(JKActionSheet * tempActionSheet, NSInteger index, NSString * buttonTitle);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@property (nonatomic, copy, readonly) NSString * destructiveButtonTitle;
@property (nonatomic, copy, readonly) NSString * cancelButtonTitle;
@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex;



/**
 UIStatusBar的父视图，添加在其上面的View，可以盖住UIStatusBar

 @return UIStatusBar的父视图
 */
- (UIView *)statusBarContentView;


/**
 仿微信ActionSheet样式活动弹窗

 @param cancelButtonTitle cancelButtonTitle description
 @param destructiveButtonTitle destructiveButtonTitle description
 @param otherButtonTitles otherButtonTitles description
 @return 仿微信ActionSheet
 */
- (instancetype)initWithCancelButtonTitle:(nullable NSString *)cancelButtonTitle
                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                        otherButtonTitles:(nullable NSArray <NSString *>*)otherButtonTitles;



/**
 弹出ActionSheet，并设置处理事件的Block

 @param view ActionSheet所在的View
 @param actionHandle 处理事件的Block
 */
- (void)showInView:(nonnull UIView *)view actionHandle:(nullable JKActionSheetHandle)actionHandle;



/**
 更新UI

 @param otherButtonTitles otherButtonTitles description
 */
- (void)reloadWithOtherButtonTitles:(nullable NSArray <NSString *>*)otherButtonTitles;

@end

NS_ASSUME_NONNULL_END
