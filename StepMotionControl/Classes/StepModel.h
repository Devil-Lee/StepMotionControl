//
//  StepModel.h
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepModel : NSObject

@property(nonatomic, strong) NSDate *date;

@property(nonatomic, strong) NSString *record_time;

@property(nonatomic, assign) int step;

@property(nonatomic, assign) double accelerationX;

@property(nonatomic, assign) double accelerationY;

@property(nonatomic, assign) double accelerationZ;

@property(nonatomic, assign) double rotatingVectorX;

@property(nonatomic, assign) double rotatingVectorY;

@property(nonatomic, assign) double rotatingVectorZ;

@property(nonatomic, assign) double latitude;

@property(nonatomic, assign) double longitude;

//g是一个震动幅度的系数,通过一定的判断条件来判断是否计做一步
@property(nonatomic,assign) double g;

@end

