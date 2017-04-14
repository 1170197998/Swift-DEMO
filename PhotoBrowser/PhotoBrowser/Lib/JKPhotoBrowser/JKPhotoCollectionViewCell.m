//
//  JKPhotoCollectionViewCell.m
//  ZoomScrollView
//
//  Created by 蒋鹏 on 16/6/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "JKPhotoCollectionViewCell.h"
#import "JKPhotoManager.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"

NSString * const JKPhotoCollectionViewCellKey = @"JKPhotoCollectionViewCell";

@interface JKPhotoCollectionViewCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, strong)UIImageView * imageView;


/**
 长按保存到相册
 */
@property (nonatomic, weak) UILongPressGestureRecognizer * longPress;




/**
 指向JKPhotoManager.collectionView
 */
@property (nonatomic, weak) UICollectionView * collectionView;



@property (nonatomic, weak, readonly) JKPhotoModel * model;


#pragma mark - 拖拽手势相关


/**
 拖拽手势，实现偏移、缩放、背景渐变
 */
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;


/**
 原始坐标的中心点，用来还原坐标
 */
@property (nonatomic, assign) CGPoint imageViewOriginalCenter;


/**
 长按手势的初始坐标，用来坐标偏移大小和方法
 */
@property (nonatomic, assign) CGPoint panGestureBeginPoint;


/**
 拖拽手势上一次的触屏点location坐标点
 */
@property (nonatomic, assign) CGFloat panGestureLocationY;


/**
 在panGesture的响应方法中，location = [panGesture locationInView:self.contentView]来判断拖拽的方向，end和move(change)状态的location是一样的，没法比较方向。用displayLink定时取location则可以判断方法
 */
@property (nonatomic, strong) CADisplayLink * displayLink;


/**
 向下则隐藏图片，向上则缩放到到1.0比例
 */
@property (nonatomic, assign) BOOL isPanGestureDirectionDown;

@end


@implementation JKPhotoCollectionViewCell


- (BOOL)isValidURLString:(NSString *)url {
    NSString * match = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate * regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",match];
    return [regex evaluateWithObject:url];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        /// UIScrollView自带缩放功能，方便实现缩放
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:JK_MainScreen()];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.maximumZoomScale = 3;
        scrollView.delegate = self;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        
        self.imageView = [[UIImageView alloc]initWithFrame:JK_MainScreen()];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.imageView];
        
        /// 最小0.2，默认是1.0，就不能实现缩小
        self.scrollView.minimumZoomScale = 0.2;
        
        self.imageView.userInteractionEnabled = YES;
        
        /// 单击消失
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.imageView addGestureRecognizer:singleTap];
        
        /// 双击缩放
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        /// 长按保存到相册
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestrue:)];
        [self.imageView addGestureRecognizer:longPress];
        self.longPress = longPress;
        
        /// 拖拽手势，实现缩放、偏移、背景渐变效果
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGesture:)];
        self.panGesture.delaysTouchesEnded = NO;
        self.panGesture.maximumNumberOfTouches = 1;
        [self.imageView addGestureRecognizer:self.panGesture];
        
        /// 在协议方法中实现panGesture和collectionView.panGestureRecognizer“并发”处理手势
        /// shouldRecognizeSimultaneouslyWithGestureRecognizer:
        self.panGesture.delegate = self;
        
    }return self;
}



- (void)refreshCellWithModel:(JKPhotoModel *)model
              collectionView:(UICollectionView *)collectionView
                 bigImageUrl:(NSString *)imageUrl
            placeholderImage:(UIImage *)placeholderImage
         isTheImageBeTouched:(BOOL)isTheImageBeTouched {
    
    self.collectionView = collectionView;
    
    if (imageUrl && [self isValidURLString:imageUrl]) {
        [self.imageView sd_setShowActivityIndicatorView:YES];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage options:SDWebImageCacheMemoryOnly];
    } else if (model.smallPicurl && [self isValidURLString:model.smallPicurl]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.smallPicurl] placeholderImage:placeholderImage];
    } else {
        self.imageView.image = model.imageView.image;
    }
    _model = model;
    
    /// 设置内容填充方式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = NO;
    
    
    /// 被点击的图片有放大效果
    if (isTheImageBeTouched) {
        // 可能会出现某些控制器的控件算出的相对frame的Y坐标小20
        CGRect newImageViewFrame = [model.imageView.superview convertRect:model.imageView.frame toView:JKPhotoBrowser().jk_keyWindow];
        self.imageView.frame = newImageViewFrame;
        
        [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.imageView.frame = JK_MainScreen();
        } completion:nil];
    } else {
        self.imageView.frame = JK_MainScreen();
    }
    
    self.scrollView.contentSize = JK_MainScreen().size;

    
    /// 保存原始frame的中心坐标
    self.imageViewOriginalCenter = CGPointMake(self.contentView.bounds.size.width / 2.0, self.contentView.bounds.size.height / 2.0);
}

- (void)collectionViewWillDisplayCell {
    self.model.imageView.hidden = self.jk_hidesOriginalImageView;
}


- (void)collectionViewDidEndDisplayCell {
    self.imageView.center = self.imageViewOriginalCenter;
    self.model.imageView.hidden = NO;
    
    /// 释放displayLink
    if (_displayLink) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = nil;
    }
}

- (void)makeContentViewTransparentWithAlpha:(CGFloat)alpha {
    if ([self.delegate respondsToSelector:@selector(jk_makeContentViewTransparentWithAlpha:)]) {
        [self.delegate jk_makeContentViewTransparentWithAlpha:alpha];
    }
}



- (void)handleDispalyLinkAction:(CADisplayLink *)displayLink {
    CGPoint location = [self.panGesture locationInView:self.contentView];
    
    /// 计算手势是向下还是向上滑
    if (location.y != self.panGestureLocationY) {
        if (self.panGestureLocationY < location.y - 0.5) {
            self.isPanGestureDirectionDown = YES;
        } else {
            self.isPanGestureDirectionDown = NO;
        }
        
        /// 记录最后一次的手势作用点
        self.panGestureLocationY = location.y;
    }
    
    
    if (self.panGesture.state == UIGestureRecognizerStateChanged &&
        JKPhotoBrowser().jk_isContentViewScrolling == NO) {
        
        /// 相比上一次的location点在X/Y轴方向的间隔
        CGFloat verticalMargin = location.y - self.panGestureBeginPoint.y;
        CGFloat horizontalMargin = location.x - self.panGestureBeginPoint.x;
        
        /// 向下划，做缩小、透明动画
        if (verticalMargin > 0) {
            CGFloat height = self.contentView.bounds.size.height / 2.0;
            CGFloat scale = 1 - (verticalMargin / height) * 0.5;
            self.scrollView.zoomScale = scale;
            scale = 1 - verticalMargin / height;
            
            [self makeContentViewTransparentWithAlpha:scale];
            
        } else  {
            /// 向上，保持1.0比例
            self.scrollView.zoomScale = 1.0;
            [self makeContentViewTransparentWithAlpha:1.0];
        }
        
        /// 无论向上、向下都进行位移
        if (self.collectionView.panGestureRecognizer.enabled == NO) {
            self.imageView.center = CGPointMake(self.imageViewOriginalCenter.x + horizontalMargin, self.imageViewOriginalCenter.y + verticalMargin);
        }
    }
    
}

- (void)handlepanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint location = [panGesture locationInView:self.contentView];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        /// 记录初始点
        self.panGestureBeginPoint = location;
        
        /// 1.如果底层的CollectionView发生左右滚动，则self.imageView不响应self.panGesture
        /// 2.如果self.imageView响应self.panGesture,则关闭CollectionView.panGestureRecognizer
    } else if (panGesture.state == UIGestureRecognizerStateChanged &&
               JKPhotoBrowser().jk_isContentViewScrolling == NO) {
        
        CGFloat verticalMargin = location.y - self.panGestureBeginPoint.y;
        CGFloat horizontalMargin = location.x - self.panGestureBeginPoint.x;
        
        /// 1.相对初始点而言必须向下划，2.向下偏左、偏右 45度以内
        if (verticalMargin > 0 && verticalMargin > fabs(horizontalMargin)) {
            
            /// 关闭底层collectionView.panGestureRecognizer,由self.imageView响应self.panGesture,防止左右滚动。在手势结束state == UIGestureRecognizerStateEnded的时候重新开启
            
            if (self.collectionView.panGestureRecognizer.isEnabled) {
                self.collectionView.panGestureRecognizer.enabled = NO;
            }
            
            /// 启动定时器，进行缩放、位移计算，displayLink计算的位移相比在此处计算更加精准
            if (self.displayLink.isPaused) {
                self.displayLink.paused = NO;
            }
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded ) {
        
        /// 暂停定时器
        if (self.displayLink.isPaused == NO) {
            self.displayLink.paused = YES;
        }
        
        /// 重新开启self.collectionView.panGestureRecognizer
        if (self.collectionView.panGestureRecognizer.enabled == NO) {
            self.collectionView.panGestureRecognizer.enabled = YES;
            
            
            /// 最后的手势不是向下，则将imageView还原到1.0比例，并移到原始中心点
            if (self.isPanGestureDirectionDown == NO) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.scrollView.zoomScale = 1.0;
                    [self makeContentViewTransparentWithAlpha:1.0];
                    self.imageView.center = self.imageViewOriginalCenter;
                }];
            } else {
                
                /// 如果左右的手势是向下的，则执行退出（消失）动画
                [self handleSingleTapGesture:nil];
            }
        }
    }
}


- (void)handleSingleTapGesture:(UITapGestureRecognizer *)tap{
    UIImageView * imageView = self.imageView;
    BOOL visible = NO;
    
    CGRect newImageViewFrame = CGRectZero;
    if ([self.model.contentView isKindOfClass:[UITableView class]]) {
        if (self.model.imageView && self.model.cell) {
            UITableView * tableView = (UITableView *)self.model.contentView;
            UITableViewCell * cell = (UITableViewCell *)self.model.cell;
            
            /// (对于聊天界面,Cell的复用会导致ImageView的复用，动画效果会有些偏差)
            visible = [tableView.visibleCells containsObject:cell];
        }
    } else if ([self.model.contentView isKindOfClass:[UICollectionView class]]){
        if (self.model.imageView && self.model.cell) {
            UICollectionView * colletionView = (UICollectionView *)self.model.contentView;
            UICollectionViewCell * cell = (UICollectionViewCell *)self.model.cell;
            
            /// (对于聊天界面,Cell的复用会导致ImageView的复用，动画效果会有些偏差)
            visible = [colletionView.visibleCells containsObject:cell];
        }
    } else {
        newImageViewFrame = [self.model.imageView.superview convertRect:self.model.imageView.frame toView:JKPhotoBrowser().jk_keyWindow];
        visible = CGRectContainsRect(JKPhotoBrowser().jk_keyWindow.frame, newImageViewFrame);
    }
    
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
    CGSize imageSize = self.imageView.image.size;
    
    /// 根据图片的比例调整ImageView的frame,不然动画可能会比较突兀
    /// 左右留空
    if (imageSize.width / imageSize.height < self.imageView.frame.size.width / self.imageView.frame.size.height) {
        CGFloat newWidth = self.imageView.frame.size.height * (imageSize.width / imageSize.height) ;
        
        imageView.frame = CGRectMake(self.imageView.center.x - newWidth * 0.5,
                                     self.imageView.frame.origin.y,
                                     newWidth,
                                     self.imageView.frame.size.height);
    } else {
        /// 上下留空
        CGFloat newHeight = self.imageView.frame.size.width * (imageSize.height / imageSize.width);
        
        imageView.frame = CGRectMake(self.imageView.frame.origin.x,
                                     self.imageView.center.y - newHeight * 0.5,
                                     self.imageView.frame.size.width,
                                     newHeight);
    }
    
    
    // 可能会出现某些控制器的控件算出的相对frame的Y坐标小20
    if (CGRectEqualToRect(newImageViewFrame, CGRectZero)) {
        newImageViewFrame = [self.model.imageView.superview convertRect:self.model.imageView.frame toView:JKPhotoBrowser().jk_keyWindow];
    }

    /// 隐藏PageControl
    if ([self.delegate respondsToSelector:@selector(jk_hidesPageControlIfNeed)]) {
        [self.delegate jk_hidesPageControlIfNeed];
    }

    self.imageView.contentMode = self.model.imageView.contentMode;
    self.imageView.clipsToBounds = self.model.imageView.clipsToBounds;
    
    /// 退出动画 (对于聊天界面,Cell的复用会导致ImageView的复用，动画效果会有些偏差)
    [UIView animateWithDuration:0.18 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (visible) {
            imageView.frame = newImageViewFrame;
        } else {
            imageView.hidden = YES;
        }
        [self makeContentViewTransparentWithAlpha:0];

    } completion:^(BOOL finished) {
        self.model.imageView.hidden = NO;
        
        if (finished) {
            if ([self.delegate respondsToSelector:@selector(jk_didClickedImageView:visible:)]) {
                [self.delegate jk_didClickedImageView:self.imageView visible:visible];
            }
        }
        imageView.hidden = NO;
    }];
}


/// 双击
- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale <= 1.0) {
        [self.scrollView setZoomScale:2.0 animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}



/// 长按
- (void)handleLongPressGestrue:(UILongPressGestureRecognizer *)longGesture{
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        UIImageView * imageView = (UIImageView *)longGesture.view;
        
        if ([self.delegate respondsToSelector:@selector(jk_didLongPressImageView:)]) {
            [self.delegate jk_didLongPressImageView:imageView];
        }
    }
}





#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    /// 实时调整scrollView.contentSize，scrollView.zoomScale会调整viewForZooming的frame
    self.scrollView.contentSize = view.frame.size;
    
    
    /// 处理捏合手势，如果scale < 1.0，就动态放大到1.0比例
    if (scrollView.pinchGestureRecognizer.scale < 1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    /// 让self.pagGesture 和 collectionView.panGestureRecognizer能够同时响应手势
    /// 然后在self.pagGesture的响应方法中根据拖拽的方向、角度控制collectionView.panGestureRecognizer.enable
    /// collectionView.panGestureRecognizer.enable = NO时，self.pagGesture会优先响应拖拽手势
    
    if ([otherGestureRecognizer isEqual:self.collectionView.panGestureRecognizer]) {
        return YES;
    }return NO;
}


#pragma mark - displayLink


- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDispalyLinkAction:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }return _displayLink;
}

@end
