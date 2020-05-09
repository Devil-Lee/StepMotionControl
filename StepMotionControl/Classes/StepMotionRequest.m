//
//  StepMotionRequest.m
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//

#import "StepMotionRequest.h"
#import "StepModel.h"

@interface StepMotionRequest ()
@property (nonatomic, copy, nullable) SuccessBlock successHandler;
@property (nonatomic, copy, nullable) FailureBlock failureHandler;
@end

@implementation StepMotionRequest

- (void)startWithStepModel:(StepModel *)stepModel SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    self.successHandler = success;
    self.failureHandler = failure;
    [self sendRequestWithStepModel:stepModel];
}

- (void)sendRequestWithStepModel:(StepModel *)stepModel {
    NSURLSession *session=[NSURLSession sharedSession];
    NSURL *url=[NSURL URLWithString:@"http://123.207.175.144/Test1.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[@"Login=1" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
    }];
    [dataTask resume];
}

@end
