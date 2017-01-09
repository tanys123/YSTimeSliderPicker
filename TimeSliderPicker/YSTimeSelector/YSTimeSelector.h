//
//  YSTimeSelector.h
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTime.h"

@class YSTimeSelector;

@protocol YSTimeSelectorDelegate <NSObject>

@optional
- (void)ysTimeSelector:(YSTimeSelector *)timeSelector onChangeFromTime:(YSTime *)fromTime toTime:(YSTime *)toTime;

@end

@interface YSTimeSelector : UIView

@property (nonatomic, weak) id<YSTimeSelectorDelegate> delegate;

@property (nonatomic, strong) YSTime *minTimeRange;
@property (nonatomic, strong) YSTime *maxTimeRange;
@property (nonatomic, strong) YSTime *fromTime;
@property (nonatomic, strong) YSTime *toTime;

@property (nonatomic, strong) UIColor *lineIndicatorColor;
@property (nonatomic, strong) UIColor *timeLabelColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic) NSInteger divideByMinutes;

- (instancetype)initWithTimeRangeMin:(YSTime *)minTime toMax:(YSTime *)maxTime;
- (void)setFromTime:(YSTime *)fromTime toTime:(YSTime *)toTime scrollTo:(BOOL)needScroll;

@end
