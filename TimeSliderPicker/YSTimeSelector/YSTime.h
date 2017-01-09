//
//  YSTime.h
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultHour 8
#define kDefaultMinute 0

typedef enum PeriodType : NSUInteger {
    kAM,
    kPM
} PeriodType;

@interface YSTime : NSObject

- (instancetype)initWith24HourFormat:(NSInteger)hour minute:(NSInteger)minute;

// In 24 hour format
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;

// In 12 hour format
@property (nonatomic) NSInteger hour12F;
@property (nonatomic) PeriodType period;

#pragma mark - Public Methods
- (void)setHour:(NSInteger)hour andMinute:(NSInteger)minute;
- (void)addMinute:(NSInteger)minute;
- (void)addHour:(NSInteger)hour;
- (NSString *)to12HourString;
- (BOOL)isOnlyHour;
- (BOOL)isEqualToTime:(YSTime *)time;
- (BOOL)isBiggerThanTime:(YSTime *)time;

@end
