//
//  YSTimeLineIndicator.h
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTime.h"

@interface YSTimeLineIndicator : UIView

@property (nonatomic, strong) YSTime *time;
@property (nonatomic, weak) UILabel *timeLabel;

- (instancetype)initWithFrame:(CGRect)frame andTime:(YSTime *)time;

@end
