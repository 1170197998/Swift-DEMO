//
//  JKActionSheetCell.m
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKActionSheetCell.h"

const CGFloat JKActionSheetTableViewRowHeight = 46;

@interface JKActionSheetCell ()

@property (nonatomic, strong) UIVisualEffectView * visulEffectView;

@end


@implementation JKActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.jk_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JKMainScreenSize().width, JKActionSheetTableViewRowHeight)];
        self.jk_titleLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        self.jk_titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIBlurEffect * visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visulEffectView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        self.visulEffectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.visulEffectView.frame = self.jk_titleLabel.frame;
        [self.contentView addSubview:self.visulEffectView];
        [self.visulEffectView.contentView addSubview:self.jk_titleLabel];
        
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.jk_titleLabel.frame];
        self.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        
        
    }return self;
}

- (void)configureCellWithTitle:(NSString *)title type:(JKActionSheetCellType)type {
    self.jk_titleLabel.text = title;
    self.jk_titleLabel.textColor = type == JKActionSheetCellTypeDestructive ? [UIColor redColor] : [UIColor blackColor];
    self.jk_titleLabel.font = [UIFont systemFontOfSize:18];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
