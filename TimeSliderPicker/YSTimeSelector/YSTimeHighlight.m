//
//  YSTimeHighlight.m
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import "YSTimeHighlight.h"


@implementation YSTimeHighlight

static CGFloat ThumbWidth = 15;
static CGFloat ThumbHeight = 15;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [self reFrameThumbs];
    
    [super layoutSubviews];
}

- (void)setup
{
    [self setUserInteractionEnabled:YES];
    
    _highlightView = [[UIView alloc] initWithFrame:CGRectZero];
    [_highlightView setUserInteractionEnabled:YES];
    [self addSubview:_highlightView];
    
    _lowerThumbHighlight = NO;
    _upperThumbHighlight = NO;
    
    _lowerThumb = [[UIView alloc] initWithFrame:CGRectZero];
    _lowerThumb.backgroundColor = [UIColor whiteColor];
    _lowerThumb.layer.borderWidth = 1;
    _lowerThumb.layer.borderColor = [UIColor blackColor].CGColor;
    [_highlightView addSubview:_lowerThumb];
    
    _upperThumb = [[UIView alloc] initWithFrame:CGRectZero];
    _upperThumb.backgroundColor = [UIColor whiteColor];
    _upperThumb.layer.borderWidth = 1;
    _upperThumb.layer.borderColor = [UIColor blackColor].CGColor;
    [_highlightView addSubview:_upperThumb];
}

- (void)reFrameThumbs
{
    _lowerThumb.frame = CGRectMake(_highlightView.bounds.origin.x - (ThumbWidth / 2), _highlightView.bounds.size.height / 2 - ThumbHeight / 2, ThumbWidth, ThumbHeight);
    _lowerThumb.layer.cornerRadius = _lowerThumb.frame.size.width / 2;
    
    _upperThumb.frame = CGRectMake(_highlightView.bounds.size.width - (ThumbWidth / 2), _highlightView.bounds.size.height / 2 - ThumbHeight / 2, ThumbWidth, ThumbHeight);
    _upperThumb.layer.cornerRadius = _upperThumb.frame.size.width / 2;
}

- (void)setHighlightFrame:(CGRect)frame
{
    self.frame = CGRectMake(frame.origin.x - ThumbWidth / 2, frame.origin.y, frame.size.width + ThumbWidth, frame.size.height);
    
    self.highlightView.frame = CGRectMake(ThumbWidth / 2, 0, frame.size.width, frame.size.height);
    
    [self reFrameThumbs];
}

@end
