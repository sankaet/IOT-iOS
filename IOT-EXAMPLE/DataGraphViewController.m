//
//  DataGraphViewController.m
//  IOT-EXAMPLE
//
//  Created by Sankaet Pathak on 12/6/15.
//  Copyright © 2015 Sankaet Pathak. All rights reserved.
//

#import "DataGraphViewController.h"
#import "FSLineChart.h"

@interface DataGraphViewController ()

@end

@implementation DataGraphViewController

-(NSMutableDictionary *) data{
    if (!_data) {
        _data = [[NSMutableDictionary alloc] init];
    }
    
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self chart1]];
    [self.view addSubview:[self chart2]];
    [self.view addSubview:[self chart3]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(FSLineChart*)chart1 {
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 10;
    lineChart.horizontalGridStep = 10;
    lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%li",[self.data[@"time_in_sec"][item] integerValue]];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:self.data[@"accX"]];
    return lineChart;
}

-(FSLineChart*)chart2 {
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 260, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 10;
    lineChart.horizontalGridStep = 10;
    lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%li",[self.data[@"time_in_sec"][item] integerValue]];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:self.data[@"accY"]];
    return lineChart;

}

-(FSLineChart*)chart3 {
    
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 460, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 10;
    lineChart.horizontalGridStep = 10;
    lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%li",[self.data[@"time_in_sec"][item] integerValue]];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [lineChart setChartData:self.data[@"accZ"]];
    return lineChart;
}


@end
