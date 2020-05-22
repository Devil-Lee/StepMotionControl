//
//  STEPMOTIONViewController.m
//  StepMotionControl
//
//  Created by Devil-Lee on 05/09/2020.
//  Copyright (c) 2020 Devil-Lee. All rights reserved.
//

#import "STEPMOTIONViewController.h"
#import "StepMotionManager.h"

@interface STEPMOTIONViewController ()

@property (nonatomic, strong) UILabel *stepLabel;

@end

@implementation STEPMOTIONViewController {
    NSString* _userId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubViews];
    _userId = @"GCKTest";
  //[[StepMotionManager sharedManager] startMonitorStepChangesWithUserId:_userId];
    [[StepMotionManager sharedManager]resumeToLastMonitorStepChangesWithUserId:_userId];
//    [[StepMotionManager sharedManager] startMonitorStepChanges:^(__kindof StepModel *stepModel) {
//        NSLog(@"record_time, %@",stepModel.record_time);
//        NSLog(@"accelerationX, %f",stepModel.accelerationX);
//        NSLog(@"accelerationY, %f",stepModel.accelerationY);
//        NSLog(@"accelerationZ, %f",stepModel.accelerationZ);
//        NSLog(@"rotatingVectorX, %f",stepModel.rotatingVectorX);
//        NSLog(@"rotatingVectorY, %f",stepModel.rotatingVectorY);
//        NSLog(@"rotatingVectorZ, %f",stepModel.rotatingVectorZ);
//        NSLog(@"latitude, %f",stepModel.latitude);
//        NSLog(@"longitude, %f",stepModel.longitude);
//        NSLog(@"-------------------");
//    }];
    

    
}

- (void)setupSubViews {
    self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
    self.stepLabel.font = [UIFont systemFontOfSize:15.0];
//    self.stepLabel.text = [NSString stringWithFormat:@"用户已经走了%@步", [StepMotionManager sharedManager].step];
    
    [self.view addSubview:self.stepLabel];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[StepMotionManager sharedManager]endMonitorStepChanges];
}
- (IBAction)startBtnTouched:(id)sender {
    [[StepMotionManager sharedManager] startMonitorStepChangesWithUserId:_userId];
}

- (IBAction)resumeBtnTouched:(id)sender {
    [[StepMotionManager sharedManager]resumeToLastMonitorStepChangesWithUserId:_userId];
    
}
- (IBAction)ennBtnTouched:(id)sender {
     [[StepMotionManager sharedManager]endMonitorStepChanges];
}

@end
