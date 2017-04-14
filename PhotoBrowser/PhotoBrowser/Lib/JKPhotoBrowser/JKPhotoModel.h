//
//  JKPhotoModel.h
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKPhotoModel : NSObject

/**    图片所在的imageView    */
@property (nonatomic, weak) UIImageView * imageView;


/**    图片的URL    */
@property (nonatomic, copy) NSString * smallPicurl;


/**    图片所在的tableViewCell / CollectionViewCell    */
@property (nonatomic, weak) UIView * cell;


/**    图片所在的TableView / CollectionView / View   */
@property (nonatomic, weak) UIView * contentView;



/**
 实例化JKPhotoBrowser用到的Model，绑定相关的imageView、imageUrl、cell、contentView

 @param imageView imageView description
 @param smallPicUrl smallPicUrl description
 @param cell cell description
 @param contentView 图片所在的TableView / CollectionView / View
 @return model
 */
+ (instancetype)modelWithImageView:(UIImageView *)imageView
                       smallPicUrl:(NSString *)smallPicUrl
                              cell:(UIView *)cell
                       contentView:(UIView *)contentView;

@end
