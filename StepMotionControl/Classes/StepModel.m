//
//  StepModel.m
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//
//测试一下能不能更新版本
#import "StepModel.h"

@implementation StepModel
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeInt64:self.timpstamp forKey:@"timestamp"];
    [coder encodeInt:self.step forKey:@"step"];
    [coder encodeDouble:self.accelerationX forKey:@"accelerationX"];
    [coder encodeDouble:self.accelerationY forKey:@"accelerationY"];
    [coder encodeDouble:self.accelerationZ forKey:@"accelerationZ"];
    [coder encodeDouble:self.rotatingVectorX forKey:@"rotatingVectorX"];
    [coder encodeDouble:self.rotatingVectorY forKey:@"rotatingVectorY"];
    [coder encodeDouble:self.rotatingVectorZ forKey:@"rotatingVectorZ"];
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeDouble:self.g forKey:@"g"];
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.date = [coder decodeObjectForKey:@"date"];
        self.step = [coder decodeIntForKey:@"step"];
        self.timpstamp = [coder decodeInt64ForKey:@"timestamp"];
        self.accelerationX = [coder decodeDoubleForKey:@"accelerationX"];
        self.accelerationY = [coder decodeDoubleForKey:@"accelerationY"];
        self.accelerationZ = [coder decodeDoubleForKey:@"accelerationZ"];
        self.rotatingVectorX = [coder decodeDoubleForKey:@"rotatingVectorX"];
        self.rotatingVectorY = [coder decodeDoubleForKey:@"rotatingVectorY"];
        self.rotatingVectorZ = [coder decodeDoubleForKey:@"rotatingVectorZ"];
        self.latitude = [coder decodeDoubleForKey:@"latitude"];
        self.longitude = [coder decodeDoubleForKey:@"longitude"];
        self.g = [coder decodeDoubleForKey:@"g"];
    }
    return self;
}
@end
