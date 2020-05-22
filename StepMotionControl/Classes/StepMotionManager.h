//
//  StepMotionManager.h
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StepModel.h"

//typedef void (^StepChangeBlock)(__kindof StepModel *stepModel);

@interface StepMotionManager : NSObject
/**
 运动步数（总计）
 */
@property (nonatomic, assign) NSInteger step;

+ (StepMotionManager *)sharedManager;
/**
  开始监控步数变化
*/
//- (void)startMonitorStepChanges:(StepChangeBlock)change WithUserId:(NSString *)userId;
- (void)startMonitorStepChangesWithUserId:(NSString *)userId;

/**
 结束监控步数变化
*/
- (void)endMonitorStepChanges;

/**
 恢复至上次的步数监测
 */
- (void)resumeToLastMonitorStepChangesWithUserId:(NSString *)userId;

@end
