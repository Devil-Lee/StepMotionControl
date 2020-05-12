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

@property(nonatomic, assign) long timpstamp; //记录时间戳

@property(nonatomic, assign) int step;

@property(nonatomic, assign) double accelerationX; //抵消重力沿X轴的加速度

@property(nonatomic, assign) double accelerationY; //抵消重力沿Y轴的加速度

@property(nonatomic, assign) double accelerationZ; //抵消重力沿Z轴的加速度

@property(nonatomic, assign) double rotatingVectorX; //旋转向量沿X轴分量

@property(nonatomic, assign) double rotatingVectorY; //旋转向量沿Y轴分量

@property(nonatomic, assign) double rotatingVectorZ; //旋转向量沿Z轴分量

@property(nonatomic, assign) double latitude; //所在纬度

@property(nonatomic, assign) double longitude; //所在经度

//g是一个震动幅度的系数,通过一定的判断条件来判断是否计做一步
@property(nonatomic,assign) double g;

@end

