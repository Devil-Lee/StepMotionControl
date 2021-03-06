//
//  StepMotionRequest.m
//  MotionControl
//
//  Created by lee on 2020/4/30.
//  Copyright © 2020 lee. All rights reserved.
//
 
#import "StepMotionRequest.h"
#import "StepModel.h"

//上传跑步信息的url
#define COMMITRUNDATA_URL   [NSURL URLWithString:@"https://run.topviewclub.cn/run/commitRunData"]

@interface StepMotionRequest ()
@property (nonatomic, copy, nullable) SuccessBlock successHandler;
@property (nonatomic, copy, nullable) FailureBlock failureHandler;

@property (nonatomic, strong) NSString *userId; //跑步者Id
@end

@implementation StepMotionRequest

- (void)startWithPresentSteps:(NSArray *)steps UserId:(NSString *)userId SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    self.successHandler = success;
    self.failureHandler = failure;
    self.userId = userId;
    [self sendRequestWithSteps:steps];
}

- (void)sendRequestWithSteps:(NSArray *)steps {
    //判空
    if(!steps || steps.count == 0) {
        NSDictionary *responsedict = @{
            @"message"  :  @"跑步数据为空",
            @"code"     :  [NSNumber numberWithLong:400],
            @"success"  :  @NO,
            @"data"     :  @NO
                              };
        self.successHandler(nil, responsedict);
        return;

    }
    //配置session
    NSURLSessionConfiguration *sessionConfigure = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfigure.HTTPAdditionalHeaders = @{ @"Content-Type": @"application/json" };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfigure];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:COMMITRUNDATA_URL];
    request.HTTPMethod =  @"POST";
    
    //data数组
     NSMutableArray *dataArr = [NSMutableArray array];
    NSArray *keyArr = @[@"accelerateX", @"accelerateY", @"accelerateZ", @"rotationX", @"rotationY", @"rotationZ", @"longitude", @"latitude", @"timestamp"];
    NSMutableArray *temp = [NSMutableArray array];
    for(StepModel *model in steps){
       NSArray *arr =  [NSArray arrayWithObjects:[NSNumber numberWithDouble: model.accelerationX], [NSNumber numberWithDouble: model.accelerationY], [NSNumber numberWithDouble: model.accelerationZ], [NSNumber numberWithDouble: model.rotatingVectorX], [NSNumber numberWithDouble: model.rotatingVectorY], [NSNumber numberWithDouble: model.rotatingVectorZ], [NSNumber numberWithDouble: model.longitude], [NSNumber numberWithDouble: model.latitude], [NSNumber numberWithLong:model.timpstamp], nil];
        [temp addObject:arr];
    }
    NSArray *valueArr = temp;
    [dataArr addObject:keyArr];
    [dataArr addObjectsFromArray:valueArr];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dataArr options:kNilOptions error:nil];
   // Byte *testByte = (Byte *)[jsondata bytes];
    
    NSString *jsonStr = [NSString stringWithUTF8String:[jsondata bytes]];
    NSDictionary *dict = @{
        @"userId" : self.userId,
        @"data" : jsonStr
                          };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    id object = [NSJSONSerialization JSONObjectWithData:[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil] options:kNilOptions error:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([responseObject[@"message"] isEqual: @"success"]) {
        self.successHandler((StepMotionRequest *)request, responseObject);
        }
        else {
            self.failureHandler((StepMotionRequest *)request, responseObject);
        }
        NSLog(@"%@",responseObject);
    }];
    [dataTask resume];
}

@end
