//
//  StepMotionManager.m
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//

#import "StepMotionManager.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "StepMotionRequest.h"


// 设备传感器更新间隔 (秒)
#define ACCELERO_UPDATE_TIME 0.1

// 定位功能最小更新距离 (米)
#define LOCATION_UPDATE_MIN 1

// 存放本地步数数组的路径
#define LOCAL_STEPS_PATH   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"presentSteps.archive"]

@interface StepMotionManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;


@property (nonatomic, retain) NSMutableArray *rawSteps; // 设备传感器采集的原始数组
@property (nonatomic, retain) NSMutableArray *presentSteps; // 步数数组
//@property (nonatomic, copy) StepChangeBlock stepChangeBlock; //暴露接口回调


@property (nonatomic,assign) BOOL isRunning;

@end

@implementation StepMotionManager

static StepMotionManager *sharedManager;

+ (StepMotionManager *)sharedManager {
    @synchronized (self) {
        if (!sharedManager) {
            sharedManager = [[StepMotionManager alloc] init];
        }
    }
    return sharedManager;
}
#pragma mark 读写数据操作
//读取本地存储的步数数组数据
- (NSArray *)readLocalStepsData {
    NSArray *localSteps = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCAL_STEPS_PATH];
    return localSteps;
}

//将步数数组数据存入本地(返回BOOL说明是否写入成功)
- (BOOL)writeStepsToLocalData:(NSArray *)steps {
  return [NSKeyedArchiver archiveRootObject:steps toFile:LOCAL_STEPS_PATH];
}
//开始监控步数变化
- (void)startMonitorStepChangesWithUserId:(NSString *)userId {
    
    //判断是否重复调用
    if(self.isRunning && self.isRunning == YES) {
        @throw [NSException exceptionWithName:@"MonitorUsingError" reason:@"Repeated call startMonitorStepChangesOrEndMonitorStepChanges" userInfo:nil];
    }
    self.isRunning =YES;
    
    self.userId = userId;
//    self.stepChangeBlock = change;
    self.step = 0;

    self.motionManager = [[CMMotionManager alloc] init];
    if (!self.motionManager.isAccelerometerAvailable || !self.motionManager.isGyroAvailable) {
        NSLog(@"加速计，陀螺仪传感器无法使用");
        return;
    } else {
        self.motionManager.accelerometerUpdateInterval = ACCELERO_UPDATE_TIME;
        self.motionManager.gyroUpdateInterval = ACCELERO_UPDATE_TIME;
    }

    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        //ios9之后需要调用此api,才能实现后台定位
        if (@available(iOS 9.0, *)) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        } else {
            // Fallback on earlier versions
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = LOCATION_UPDATE_MIN;
        [self.locationManager startUpdatingLocation];
    }
    
    [self startMotionManager];
}

//恢复上次监控步数变化
- (void)resumeToLastMonitorStepChangesWithUserId:(NSString *)userId{
    self.presentSteps = [NSMutableArray arrayWithArray: [self readLocalStepsData]];
    self.step = self.presentSteps.count;
    [self startMonitorStepChangesWithUserId:userId];
    
}
//结束监控步数变化
- (void)endMonitorStepChanges {
    //判断是否重复调用
   if(!self.isRunning || self.isRunning == NO) {
       @throw [NSException exceptionWithName:@"MonitorUsingError" reason:@"Repeated call startMonitorStepChangesOrEndMonitorStepChanges" userInfo:nil];
   }
    self.isRunning = NO;
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
    [self.locationManager stopUpdatingLocation];
    [self handleStepsDidWhenStopMonitor];
}

//结束监控时处理数据
- (void)handleStepsDidWhenStopMonitor {
    StepMotionRequest *request = [[StepMotionRequest alloc] init];
      //上传步数数组
    [request startWithPresentSteps:self.presentSteps UserId:self.userId SuccessHandler:^(__kindof StepMotionRequest *request, id responseObj) {
        //上传成功清楚本地数据
        self.step = 0;
        [self.rawSteps removeAllObjects];
        [self.presentSteps removeAllObjects];
    } failureHandler:^(__kindof StepMotionRequest *request, id responseObj) {
        
    }];
    
   
    
    
}
//监控步数变化
- (void)startMotionManager {
    @try {
        //判断CMMotionManager是否支持加速度计、陀螺仪
        if (!self.motionManager.accelerometerAvailable || !self.motionManager.gyroAvailable) {
            NSLog(@"CMMotionManager不支持加速度计、陀螺仪，无法获取相关数据");
            return;
        }

        if (self.rawSteps == nil) {
            self.rawSteps = [[NSMutableArray alloc] init];
        } else {
            [self.rawSteps removeAllObjects];
        }

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        // 实时获取相关数据
        __weak typeof (self) weakSelf = self;
        [self.motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {}];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
           // NSLog(@"%@", [NSThread currentThread]);
            if (!weakSelf.motionManager.isAccelerometerActive || !weakSelf.motionManager.isGyroActive) {
                NSLog(@"设备传感器状态错误");
                return;
            }
            //创建步数模型
            StepModel *stepModel = [[StepModel alloc] init];

            //三个方向加速度值
            stepModel.accelerationX =  accelerometerData.acceleration.x;
            stepModel.accelerationY =  accelerometerData.acceleration.y;
            stepModel.accelerationZ =  accelerometerData.acceleration.z;

            //旋转矢量
            stepModel.rotatingVectorX =  weakSelf.motionManager.gyroData.rotationRate.x;
            stepModel.rotatingVectorY =  weakSelf.motionManager.gyroData.rotationRate.y;
            stepModel.rotatingVectorZ =  weakSelf.motionManager.gyroData.rotationRate.z;

            double g = sqrt(pow(stepModel.accelerationX, 2) + pow(stepModel.accelerationY, 2) + pow(stepModel.accelerationZ, 2)) - 1;
            stepModel.g = g;

            stepModel.latitude = weakSelf.locationManager.location.coordinate.latitude;
            stepModel.longitude = weakSelf.locationManager.location.coordinate.longitude;
            //记录时间点
            stepModel.date = [NSDate date];
           stepModel.timpstamp =  (long)([stepModel.date timeIntervalSince1970] * 1000);
            [weakSelf.rawSteps addObject:stepModel];

            // 每采集10条数据，大约1.0s的数据时，进行分析
            if (weakSelf.rawSteps.count == 10) {
                //原始数据缓存数组
                NSMutableArray *arrBuffer = [[NSMutableArray alloc] init];

                arrBuffer = [weakSelf.rawSteps copy];
                [weakSelf.rawSteps removeAllObjects];

                // 踩点数组
                NSMutableArray *tempSteps = [[NSMutableArray alloc] init];

                //遍历原始数据缓存数组数组
                for (int i = 1; i < arrBuffer.count - 2; i++) {
                    //如果数组个数大于3,继续,否则跳出循环,用连续的三个点,要判断其振幅是否一样
                    if (![arrBuffer objectAtIndex:i - 1] || ![arrBuffer objectAtIndex:i] ||![arrBuffer objectAtIndex:i + 1]) {
                        continue;
                    }
                    StepModel *bufferPrevious = (StepModel *)[arrBuffer objectAtIndex:i - 1];
                    StepModel *bufferCurrent = (StepModel *)[arrBuffer objectAtIndex:i];
                    StepModel *bufferNext = (StepModel *)[arrBuffer objectAtIndex:i + 1];
                    //控制震动幅度,根据震动幅度让其加入踩点数组
                    if (bufferCurrent.g < -0.12 && bufferCurrent.g < bufferPrevious.g && bufferCurrent.g < bufferNext.g) {
                        [tempSteps addObject:bufferCurrent];
                    }
                }

                //初始化数据
                if (weakSelf.presentSteps == nil) {
                    weakSelf.presentSteps = [[NSMutableArray alloc] init];
                    
                }

                //踩点处理
                for (int j = 0; j < tempSteps.count; j++) {
                    StepModel *currentStep = (StepModel *)[tempSteps objectAtIndex:j];
                    if (weakSelf.motionManager.isAccelerometerActive && weakSelf.motionManager.isGyroActive) {
                        weakSelf.step ++;
                        currentStep.step = (int)weakSelf.step;
                        [weakSelf.presentSteps addObject:currentStep];
                           // 写入本地
                        [weakSelf writeStepsToLocalData:weakSelf.presentSteps];

//                        if (weakSelf.stepChangeBlock) {
//                            [weakSelf handleStepsDidChangeWithStepModel:currentStep];
//                        }
                    }
                }
                
               
                  
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        return;
    }
}

// 步数发生变化时处理逻辑
//- (void)handleStepsDidChangeWithStepModel:(StepModel *)stepModel {
//    self.stepChangeBlock(stepModel);
//
//}


#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
    switch([error code]) {
        case kCLErrorDenied: { // 用户禁止了定位权限
        } break;
        default: break;
    }
}


@end
