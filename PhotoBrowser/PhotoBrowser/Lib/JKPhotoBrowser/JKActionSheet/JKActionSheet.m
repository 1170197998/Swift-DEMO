//
//  JKActionSheet.m
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKActionSheet.h"
#import "JKActionSheetCell.h"

@interface JKActionSheet () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * backgroundButton;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, copy) NSArray * buttonTitles;


@property (nonatomic, copy) JKActionSheetHandle actionHandle;
@end

@implementation JKActionSheet





- (instancetype)initWithCancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles {
    
    if (self = [super initWithFrame:CGRectZero]) {

        _cancelButtonIndex = -1;
        
        
        NSMutableArray * mutArray = [NSMutableArray array];
        if (otherButtonTitles && otherButtonTitles.count) {
            [mutArray addObjectsFromArray:otherButtonTitles];
        }
        if (destructiveButtonTitle && destructiveButtonTitle.length) {
            [mutArray addObject:destructiveButtonTitle];
            _destructiveButtonTitle = destructiveButtonTitle;
        }
        NSMutableArray * buttonTitles = [NSMutableArray array];
        [buttonTitles addObject:mutArray.copy];
        
        if (cancelButtonTitle && cancelButtonTitle.length) {
            [buttonTitles addObject:@[cancelButtonTitle]];
            _cancelButtonTitle = cancelButtonTitle;
        }
        self.buttonTitles = buttonTitles.copy;
        
        self.backgroundButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backgroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backgroundButton addTarget:self action:@selector(didClickedBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGFloat tableViewHeight = [self buttonCount] * JKActionSheetTableViewRowHeight + (self.buttonTitles.count == 2 ? 10 : 0);
        CGRect tableViewFrame = CGRectMake(0, JKMainScreenSize().height, JKMainScreenSize().width, tableViewHeight);
        
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        [self.backgroundButton addSubview:self.tableView];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }return self;
}


- (NSUInteger)buttonCount {
    __block NSUInteger count = 0;
    [self.buttonTitles enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.count;
    }];
    return count;
}


- (void)showInView:(UIView *)view actionHandle:(nullable JKActionSheetHandle)actionHandle {
    [view addSubview:self];
    [view addSubview:self.backgroundButton];
    
    self.actionHandle = actionHandle;
    self.backgroundButton.userInteractionEnabled = NO;
    
    CGFloat tableViewHeight = self.tableView.bounds.size.height;
    CGRect tableViewFrame = CGRectMake(0, JKMainScreenSize().height - tableViewHeight, JKMainScreenSize().width, tableViewHeight);
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.tableView.frame = tableViewFrame;
    } completion:^(BOOL finished) {
        self.backgroundButton.userInteractionEnabled = YES;
    }];
}

- (void)reloadWithOtherButtonTitles:(NSArray<NSString *> *)otherButtonTitles {
    NSMutableArray * mutArray = [NSMutableArray array];
    if (otherButtonTitles && otherButtonTitles.count) {
        [mutArray addObjectsFromArray:otherButtonTitles];
    }
    
    if (self.destructiveButtonTitle) {
        [mutArray addObject:self.destructiveButtonTitle];
    }

    NSMutableArray * buttonTitles = [NSMutableArray arrayWithArray:self.buttonTitles];
    [buttonTitles replaceObjectAtIndex:0 withObject:mutArray.copy];
    self.buttonTitles = buttonTitles.copy;
    
    CGFloat tableViewHeight = [self buttonCount] * JKActionSheetTableViewRowHeight + (self.buttonTitles.count == 2 ? 10 : 0);;
    self.tableView.frame = CGRectMake(0, JKMainScreenSize().height - tableViewHeight, JKMainScreenSize().width, tableViewHeight);
    
    [self.tableView reloadData];
}

#pragma mark - TableViewProtocol



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.buttonTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JKActionSheetTableViewRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = [self.buttonTitles objectAtIndex:section];
    return array.count;
}


NSString * const JKActionSheetCellKey = @"JKActionSheetCellKey";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:JKActionSheetCellKey];
    if (!cell) {
        cell = [[JKActionSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JKActionSheetCellKey];
    }
    
    NSArray * array = [self.buttonTitles objectAtIndex:indexPath.section];
    NSString * title = [array objectAtIndex:indexPath.row];
    JKActionSheetCellType cellType = JKActionSheetCellTypeDefault;
    if (self.destructiveButtonTitle && [title isEqualToString:self.destructiveButtonTitle]) {
        cellType = JKActionSheetCellTypeDestructive;
    }
    [cell configureCellWithTitle:title type:cellType];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10.0;
    }return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        UITableViewHeaderFooterView * headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, JKMainScreenSize().width, [self tableView:tableView heightForHeaderInSection:section])];
        headerView.contentView.backgroundColor = [UIColor lightGrayColor];
        return headerView;
    }return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setPreservesSuperviewLayoutMargins:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * buttonTitle = nil;
    NSUInteger buttonIndex = self.cancelButtonIndex;
    if (indexPath.section == 0) {
        buttonTitle = [self.buttonTitles.firstObject objectAtIndex:indexPath.row];
        buttonIndex = indexPath.row;
    } else {
        buttonTitle = self.cancelButtonTitle;
    }

    [self dismissActionSheetAnimated];
    
    if (self.actionHandle) {
        self.actionHandle(self, buttonIndex, buttonTitle);
        self.actionHandle = nil;
    }
}


#pragma mark - action

- (void)dismissActionSheetAnimated {
    
    
    CGRect temp = self.tableView.frame;
    temp.origin.y = JKMainScreenSize().height;
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.tableView.frame = temp;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.backgroundButton removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


- (void)didClickedBackgroundButton:(UIButton *)button {
    [self dismissActionSheetAnimated];
}


#pragma mark - 拓展

- (UIView *)statusBarContentView {
    return [[[UIApplication sharedApplication] valueForKey:@"statusBar"] superview];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectZero];
}


- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}
@end
