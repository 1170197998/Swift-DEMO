//
//  NSObject+GCDDelayTask.h
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/9.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  参考：https://github.com/Spaceman-Labs/Dispatch-Cancel
//
//  基于GCD定时器封装，但是延时任务能随时取消，并且立刻释放相应的Block内存。
//  
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^JKGCDDelayTaskBlock)(BOOL cancel);

@interface NSObject (GCDDelayTask)



#pragma mark - 通用函数


/**
 开始延时任务
 
 @param delayInSeconds 延时
 @param block 延时任务Block
 @return JKGCDDelayTaskBlock，通过JK_CancelGCDDelayedTask()取消延时任务。
 */
JKGCDDelayTaskBlock JK_GCDDelayTaskBlock(CGFloat delayInSeconds, dispatch_block_t block);



/**
 取消延时任务
 
 @param delayedHandle JKGCDDelayTaskBlock
 */
void JK_CancelGCDDelayedTask(JKGCDDelayTaskBlock delayedHandle);





#pragma mark - 通用实例方法




/**
 主线程延时任务(单位:秒)，取调用jk_cancelGCDDelayTaskForKey:nil  取消延迟
 
 @param delayInSeconds 延时时间戳
 @param block 延时执行的Block，如果取消延迟任务则不调用，并且立刻释放内存。
 */
- (void)jk_excuteDelayTask:(CGFloat)delayInSeconds
               inMainQueue:(dispatch_block_t)block;




/**
 取消延时任务，等效[self jk_cancelGCDDelayTaskForKey:nil],对应延时方法：jk_excuteDelayTask:(CGFloat)delayInSeconds
 inMainQueue:(dispatch_block_t)block
 *
 */
- (void)jk_cancelGCDDelayTask;



#pragma mark - 特定KEY延时任务


/**
 主线程延时任务(单位:秒),取调用jk_cancelGCDDelayTaskForKey:key  取消延迟
 
 @param key 每个Block对应一个key，作为唯一标识
 @param delayInSeconds 延时
 @param block 延时执行的Block，如果取消延时任务则不调用，并且立刻释放内存。
 */
- (void)jk_excuteDelayTaskWithKey:(const void *)key
                   delayInSeconds:(CGFloat)delayInSeconds
                      inMainQueue:(dispatch_block_t)block;



/**
 取消延迟任务，并释放对应的延迟Block

 @param key \
 * 如果key == nil，对应延时方法：jk_excuteDelayTask:(CGFloat)delayInSeconds
    inMainQueue:(dispatch_block_t)block；
 *
 * 如果key != nil，对应延时方法：jk_excuteDelayTaskWithKey:(const void *)key
    delayInSeconds:(CGFloat)delayInSeconds
    inMainQueue:(dispatch_block_t)block
 */
- (void)jk_cancelGCDDelayTaskForKey:(const void *)key;



@end
