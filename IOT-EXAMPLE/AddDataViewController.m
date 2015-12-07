//
//  AddDataViewController.m
//  IOT-EXAMPLE
//
//  Created by Sankaet Pathak on 12/6/15.
//  Copyright © 2015 Sankaet Pathak. All rights reserved.
//

#import "AddDataViewController.h"
#import "AFHTTPRequestOperationManager.h"
@import CoreMotion;

@interface AddDataViewController ()
- (IBAction)toggle:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) CMMotionManager * motionManager;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation AddDataViewController{
    BOOL collecting;
    float time;
    float freq;
}

-(AFHTTPRequestOperationManager *) manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"id-a6603153-293c-4d3e-8d60-d189615c814f|secret-a41654b2-dac7-448f-8456-c7082dee439a" forHTTPHeaderField:@"X-IOT-CLIENT"];
    }
    
    return _manager;
}

-(NSMutableDictionary *) data{
    if (!_data) {
        _data = [[NSMutableDictionary alloc] init];
        _data = [@{
                   @"roll":@[],
                   @"pitch":@[],
                   @"yaw":@[],
                   @"accX":@[],
                   @"accY":@[],
                   @"accZ":@[],
                   @"time_in_sec":@[],
                   } mutableCopy];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    collecting = NO;
    freq = 0.01;
    self.motionManager = [[CMMotionManager alloc] init]; self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
}

-(void)updateDeviceMotion
{
    CMDeviceMotion *deviceMotion = self.motionManager.deviceMotion;
    
    if(deviceMotion == nil)
    {
        
        return;
        
    }
    
    CMAttitude *attitude = deviceMotion.attitude;
    CMAcceleration userAcceleration = deviceMotion.userAcceleration;
    
    float roll = attitude.roll;
    
    float pitch = attitude.pitch;
    
    float yaw = attitude.yaw;
    
    float accX = userAcceleration.x;
    
    float accY = userAcceleration.y;
    
    float accZ = userAcceleration.z;
    
    NSMutableArray* rolls = [self.data[@"roll"] mutableCopy];
    NSMutableArray* pitchs = [self.data[@"pitch"] mutableCopy];
    NSMutableArray* yaws = [self.data[@"yaw"] mutableCopy];
    NSMutableArray* accXs = [self.data[@"accX"] mutableCopy];
    NSMutableArray* accYs = [self.data[@"accY"] mutableCopy];
    NSMutableArray* accZs = [self.data[@"accZ"] mutableCopy];
    NSMutableArray* time_in_sec = [self.data[@"time_in_sec"] mutableCopy];
    
    time = time + freq;
    
    [rolls addObject:[NSNumber numberWithFloat:roll]];
    [pitchs addObject:[NSNumber numberWithFloat:pitch]];
    [yaws addObject:[NSNumber numberWithFloat:yaw]];
    [accXs addObject:[NSNumber numberWithFloat:accX]];
    [accYs addObject:[NSNumber numberWithFloat:accY]];
    [accZs addObject:[NSNumber numberWithFloat:accZ]];
    [time_in_sec addObject:[NSNumber numberWithFloat:time]];
    
    self.data[@"roll"] = rolls;
    self.data[@"pitch"] = pitchs;
    self.data[@"yaw"] = yaws;
    self.data[@"accX"] = accXs;
    self.data[@"accY"] = accYs;
    self.data[@"accZ"] = accZs;
    self.data[@"time_in_sec"] = time_in_sec;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggle:(id)sender {
    if (!collecting) {
        [self.button setTitle:@"Stop Collecting Data" forState:UIControlStateNormal];
        time = 0.0f;
        [NSTimer scheduledTimerWithTimeInterval:freq target:self selector:@selector(updateDeviceMotion) userInfo:nil repeats:YES];
        [self.motionManager startDeviceMotionUpdates];
    }else{
        [self.button setTitle:@"Start Collecting Data" forState:UIControlStateNormal];
        [self.motionManager stopDeviceMotionUpdates];
        [self postData];
    }
    collecting = !collecting;
}

- (void) postData{
    [self.manager POST:@"http://162.243.3.84/v1/schemas/5664d954c6f0c02cd6e208c9/data" parameters:self.data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseObject);
        self.data = [@{
                       @"roll":@[],
                       @"pitch":@[],
                       @"yaw":@[],
                       @"accX":@[],
                       @"accY":@[],
                       @"accZ":@[],
                       @"time_in_sec":@[],
                       } mutableCopy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}
@end
