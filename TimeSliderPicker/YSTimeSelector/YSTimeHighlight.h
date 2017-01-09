//
//  YSTimeHighlight.h
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTimeHighlight : UIView

@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UIView *lowerThumb;
@property (nonatomic, strong) UIView *upperThumb;

@property (nonatomic) BOOL lowerThumbHighlight;
@property (nonatomic) BOOL upperThumbHighlight;

- (void)setHighlightFrame:(CGRect)frame;

@end
