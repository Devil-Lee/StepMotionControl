//
//  StepMotionRequest.h
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StepMotionRequest;
@class StepModel;


// 请求结果回调
typedef void(^SuccessBlock)(__kindof StepMotionRequest *request, id responseObj);
// 请求失败回调
typedef void(^FailureBlock)(__kindof StepMotionRequest *request, NSError *error);

@interface StepMotionRequest : NSObject

- (void)startWithStepModel:(StepModel *)stepModel SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;
@end

