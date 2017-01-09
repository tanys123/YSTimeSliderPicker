//
//  ViewController.m
//  TimeSliderPicker
//
//  Created by Tan YongSheng on 09/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <YSTimeSelectorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _timeSelector.delegate = self;
    [self setTimeLabel:_timeSelector.fromTime toTime:_timeSelector.toTime];
}

- (void)setTimeLabel:(YSTime *)fromTime toTime:(YSTime *)toTime
{
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld - %02ld:%02ld", fromTime.hour, fromTime.minute, toTime.hour, toTime.minute];
}

- (IBAction)setTimeTapped:(id)sender {
    YSTime *fromTime = [[YSTime alloc] initWith24HourFormat:13 minute:30];
    YSTime *toTime = [[YSTime alloc] initWith24HourFormat:15 minute:0];
    
    [_timeSelector setFromTime:fromTime toTime:toTime scrollTo:YES];
    
    [self setTimeLabel:fromTime toTime:toTime];
}

#pragma mark - YSTimeSelectorDelegate
- (void)ysTimeSelector:(YSTimeSelector *)timeSelector onChangeFromTime:(YSTime *)fromTime toTime:(YSTime *)toTime
{
    [self setTimeLabel:fromTime toTime:toTime];
}



@end
