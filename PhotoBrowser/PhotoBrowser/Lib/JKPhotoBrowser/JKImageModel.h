//
//  JKImageModel.h
//  JKPhotoBrowser
//
//  Created by 蒋鹏 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKImageModel : NSObject

@property (nonatomic, copy, readonly) NSString * imageUrl;
@property (nonatomic, strong, readonly) NSValue * imageSize;

- (instancetype)initWithImageUrl:(NSString *)imageUrl size:(NSValue *)size;

+ (NSArray <JKImageModel *>*)models;

@end
