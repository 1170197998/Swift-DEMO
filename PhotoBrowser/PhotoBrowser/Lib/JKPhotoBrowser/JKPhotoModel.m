//
//  JKPhotoModel.m
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JKPhotoModel.h"

@implementation JKPhotoModel

+ (instancetype)modelWithImageView:(UIImageView *)imageView smallPicUrl:(NSString *)smallPicUrl cell:(UIView *)cell contentView:(UIView *)contentView {
    JKPhotoModel * model = [[JKPhotoModel alloc]init];
    model.imageView = imageView;
    model.smallPicurl = smallPicUrl;
    model.cell = cell;
    model.contentView = contentView;
    return model;
}

- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}

@end
