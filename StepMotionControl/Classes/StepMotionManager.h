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

typedef void (^StepChangeBlock)(__kindof StepModel *stepModel);

@interface StepMotionManager : NSObject

@property (nonatomic, assign) NSInteger step; // 运动步数（总计）

+ (StepMotionManager *)sharedManager;

//开始监控步数变化
- (void)startMonitorStepChanges:(StepChangeBlock)change;

//结束监控步数变化
- (void)endMonitorStepChanges;

@end
