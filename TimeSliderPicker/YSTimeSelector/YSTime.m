//
//  YSTime.m
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import "YSTime.h"

@implementation YSTime

- (instancetype)initWith24HourFormat:(NSInteger)hour minute:(NSInteger)minute
{
    self = [super init];
    if (self) {
        [self setHour:hour andMinute:minute];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setHour:kDefaultHour andMinute:kDefaultMinute];
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)setHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    [self setHour:hour];
    [self setMinute:minute];
}

- (void)addMinute:(NSInteger)minute
{
    [self setMinute:_minute + minute];
}

- (void)addHour:(NSInteger)hour
{
    [self setHour:_hour + hour];
}

- (NSString *)to12HourString
{
    NSString *periodString = _period == kAM ? @"AM" : @"PM";
    
    return [NSString stringWithFormat:@"%ld%@", (long)_hour12F, periodString];
}

- (BOOL)isOnlyHour
{
    return _minute == 0;
}

- (BOOL)isEqualToTime:(YSTime *)time
{
    return _hour == time.hour && _minute == time.minute;
}

- (BOOL)isBiggerThanTime:(YSTime *)time
{
    BOOL isBigger = NO;
    
    if (_hour == time.hour) {
        isBigger = _minute > time.minute;
    }
    else {
        isBigger = _hour > time.hour;
    }
    
    return isBigger;
}

#pragma mark - Helper Methods
- (void)setHour:(NSInteger)hour
{
    _hour = hour < 0 || hour >= 24 ? 0 : hour;
    
    // 24 hour to 12 hour 
    [self set24HourTo12Hour];
}

- (void)setMinute:(NSInteger)minute
{
    _minute = minute;
    
    if (_minute < 0) {
        _minute = 0;
    }
    else if (_minute >= 60) {
        [self addHour:_minute / 60];
        _minute = _minute % 60;
    }
}

- (void)set24HourTo12Hour
{
    if (_hour >= 12 && _hour < 24) {
        _period = kPM;
    }
    else {
        _period = kAM;
    }
    
    _hour12F = _hour;
    if (_hour > 12 && _hour < 23) {
        _hour12F = _hour - 12;
    }
    else if (_hour >= 24) {
        _hour12F = 0;
    }
}

@end
