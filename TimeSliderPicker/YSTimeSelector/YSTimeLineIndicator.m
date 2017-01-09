//
//  YSTimeLineIndicator.m
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import "YSTimeLineIndicator.h"

@interface YSTimeLineIndicator ()

@end

@implementation YSTimeLineIndicator

- (instancetype)initWithFrame:(CGRect)frame andTime:(YSTime *)time
{
    self = [super initWithFrame:frame];
    if (self) {
        _time = time;
    }
    
    return self;
}

@end
