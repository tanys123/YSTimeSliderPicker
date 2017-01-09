//
//  YSTimeSelector.m
//  TimelineSlider
//
//  Created by Tan YongSheng on 08/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import "YSTimeSelector.h"
#import "YSTimeLineIndicator.h"
#import "YSTimeHighlight.h"

#define kWidthPer30Minute 40
#define kMaxMinutePerHour 60

@interface YSTimeSelector () <UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) CGFloat viewWidth;


@property (nonatomic, strong) UIScrollView *timeScroller;
@property (nonatomic, strong) YSTimeHighlight *timeHighlight;
@property (nonatomic, strong) NSMutableArray *timeLabels;
@property (nonatomic, strong) NSMutableArray *lineIndicators;
@property (nonatomic, strong) UIPanGestureRecognizer *highlightPanGesture;

@property (nonatomic) CGPoint previousLocation;
@property (nonatomic) BOOL timeRangeChanged;

@end

@implementation YSTimeSelector

- (instancetype)init
{
    self = [super init];
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithTimeRangeMin:(YSTime *)minTime toMax:(YSTime *)maxTime
{
    self = [super init];
    if (self) {
        _minTimeRange = minTime;
        _maxTimeRange = maxTime;
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [self reframeOnNeccessaryView];
    [self redrawTime];
    
    [super layoutSubviews];
}

#pragma mark - Setup Methods
- (void)setup
{
    if (_minTimeRange == nil || _maxTimeRange == nil) {
        [self setDefaultTimeRange];
    }
    
    [self setDefaultValue];
    
    [self constructNecessaryView];
}

- (void)setDefaultTimeRange
{
    _minTimeRange = [[YSTime alloc] initWith24HourFormat:8 minute:0];
    _maxTimeRange = [[YSTime alloc] initWith24HourFormat:22 minute:0];
}

- (void)setDefaultValue
{
    _lineIndicatorColor = [UIColor lightGrayColor];
    _timeLabelColor = [UIColor blackColor];
    _divideByMinutes = 30;
    _highlightColor = [UIColor colorWithRed:153.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:0.5];
    
    _fromTime = [[YSTime alloc] initWith24HourFormat:9 minute:0];
    _toTime = [[YSTime alloc] initWith24HourFormat:10 minute:0];
}

#pragma mark - Drawing Methods
- (void)constructNecessaryView
{
    [self setUserInteractionEnabled:YES];
    
    // Scroller
    _timeScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _timeScroller.showsHorizontalScrollIndicator = NO;
    [self addSubview:_timeScroller];
    
    _timeHighlight = [[YSTimeHighlight alloc] initWithFrame:CGRectZero];
    _highlightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(timeHighlightThumbPan:)];
    _highlightPanGesture.delegate = self;
    [_timeHighlight addGestureRecognizer:_highlightPanGesture];
    [_timeScroller addSubview:_timeHighlight];
}

- (void)reframeOnNeccessaryView
{
    _viewWidth = self.bounds.size.width;
    _viewHeight = self.bounds.size.height;
    
    _timeScroller.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
}

- (void)redrawTime
{
    if (_timeLabels == nil) {
        _timeLabels = [NSMutableArray array];
    }
    if (_lineIndicators == nil) {
        _lineIndicators = [NSMutableArray array];
    }
    
    // check how many labels needed to draw
    NSInteger numLabelToDraw = [self getLabelNeededToDraw];
    
    // add / remove label from array
    NSInteger currentLabelSize = [_timeLabels count];
    if (currentLabelSize > numLabelToDraw) {
        NSInteger diff = currentLabelSize - numLabelToDraw;
        
        for (NSInteger i = currentLabelSize - 1; i >= currentLabelSize - diff; i--) {
            // label
            UILabel *timeLabel = [_timeLabels objectAtIndex:i];
            [timeLabel removeFromSuperview];
            
            [_timeLabels removeObjectAtIndex:i];
            
            // line
            YSTimeLineIndicator *line = [_lineIndicators objectAtIndex:i];
            [line removeFromSuperview];
            
            [_lineIndicators removeObjectAtIndex:i];
        }
    }
    else if (currentLabelSize < numLabelToDraw) {
        NSInteger diff = numLabelToDraw - currentLabelSize;
        
        for (NSInteger i = 0; i < diff; i++) {
            // label
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_timeScroller addSubview:timeLabel];
            
            [_timeLabels addObject:timeLabel];
            
            // line
            YSTimeLineIndicator *line = [[YSTimeLineIndicator alloc] initWithFrame:CGRectZero andTime:[[YSTime alloc] init]];
            [_timeScroller addSubview:line];
            
            [_lineIndicators addObject:line];
        }
    }
    
    
    // draw label & line indicator
    CGFloat x = 0;
    CGFloat labelWith = kWidthPer30Minute, labelHeight = 16;
    CGFloat lineWidth = 1, lineHeight = 0;
    YSTime *onGoingTime = [[YSTime alloc] initWith24HourFormat:_minTimeRange.hour minute:_minTimeRange.minute];
    YSTime *endTime = _maxTimeRange;
    for (NSInteger i = 0; i < numLabelToDraw; i++) {
        // draw label
        UILabel *timeLabel = [_timeLabels objectAtIndex:i];
        timeLabel.frame = CGRectMake(x, 0, labelWith, labelHeight);
        timeLabel.font = [UIFont systemFontOfSize:8];
        timeLabel.textColor = [_timeLabelColor copy];
        timeLabel.text = [onGoingTime to12HourString];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        
        // draw line
        lineHeight = _timeScroller.frame.size.height - (timeLabel.frame.origin.y + timeLabel.frame.size.height);
        YSTimeLineIndicator *lineIndi = [_lineIndicators objectAtIndex:i];
        lineIndi.backgroundColor = [_lineIndicatorColor copy];
        lineIndi.frame = CGRectMake(x, timeLabel.frame.origin.y + timeLabel.frame.size.height, lineWidth, lineHeight);
        lineIndi.timeLabel = timeLabel;
        lineIndi.time = [[YSTime alloc] initWith24HourFormat:onGoingTime.hour minute:onGoingTime.minute];
        
        if ([onGoingTime isOnlyHour] == NO) {
            timeLabel.text = @"";
            
            CGFloat totalHeightRemove = lineIndi.frame.size.height / 2;
            CGRect lineRect = lineIndi.frame;
            lineRect.origin.y += totalHeightRemove;
            lineRect.size.height -= totalHeightRemove;
            lineIndi.frame = lineRect;
        }
        
        if (i == numLabelToDraw - 1) {
            CGRect timeLabelRect = timeLabel.frame;
            timeLabelRect.origin.x -= timeLabelRect.size.width;
            timeLabel.frame = timeLabelRect;
            timeLabel.textAlignment = NSTextAlignmentRight;
        }
        
        x += labelWith;
        [onGoingTime addMinute:_divideByMinutes];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        CGFloat width = 0;
        for (UILabel *label in _timeLabels)
            width += label.frame.size.width;
        
        _timeScroller.contentSize = CGSizeMake(width - labelWith, _timeScroller.contentSize.height);
    });
    
    // draw highlight view
    [_timeScroller bringSubviewToFront:_timeHighlight];
    _timeHighlight.highlightView.backgroundColor = _highlightColor;
    
    CGFloat highlightX = 0;
    CGFloat highlightWidth = 0;
    YSTimeLineIndicator *fromTimeLineIndicator = nil;
    for (YSTimeLineIndicator *lineIndicator in _lineIndicators) {
        if ([_fromTime isEqualToTime:lineIndicator.time]) {
            fromTimeLineIndicator = lineIndicator;
            highlightX = fromTimeLineIndicator.frame.origin.x;
        }
        else if ([_toTime isEqualToTime:lineIndicator.time]) {
            if (fromTimeLineIndicator != nil) {
                highlightWidth = lineIndicator.frame.origin.x - fromTimeLineIndicator.frame.origin.x;
            }
        }
    }
    
    [_timeHighlight setHighlightFrame:CGRectMake(highlightX, labelHeight, highlightWidth, lineHeight)];
}

#pragma mark - Touch Event
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (_highlightPanGesture == gestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            _previousLocation = [gestureRecognizer locationInView:_timeScroller];
            
            CGRect lowerThumbRect = [_timeHighlight.highlightView convertRect:_timeHighlight.lowerThumb.frame toView:_timeScroller];
            CGRect upperThumbRect = [_timeHighlight.highlightView convertRect:_timeHighlight.upperThumb.frame toView:_timeScroller];
            
            // Add radius
            CGFloat extraHorizontalRadius = 35;
            lowerThumbRect.origin.x -= extraHorizontalRadius / 2;
            lowerThumbRect.origin.y -= extraHorizontalRadius / 2;
            lowerThumbRect.size.width += extraHorizontalRadius;
            lowerThumbRect.size.height += extraHorizontalRadius;
            upperThumbRect.origin.x -= extraHorizontalRadius / 2;
            upperThumbRect.origin.y -= extraHorizontalRadius / 2;
            upperThumbRect.size.width += extraHorizontalRadius;
            upperThumbRect.size.height += extraHorizontalRadius;
            
            if (CGRectContainsPoint(lowerThumbRect, _previousLocation)) {
                _timeHighlight.lowerThumbHighlight = YES;
                return NO;
            }
            else if (CGRectContainsPoint(upperThumbRect, _previousLocation)) {
                _timeHighlight.upperThumbHighlight = YES;
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)timeHighlightThumbPan:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
    
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint currentLocation = [panGesture locationInView:_timeScroller];
        
        if (_timeHighlight.lowerThumbHighlight) {
            [self setFromTimeFromTouch:currentLocation];
        }
        else if (_timeHighlight.upperThumbHighlight) {
            [self setToTimeFromTouch:currentLocation];
        }
        
        [self redrawTime];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateFailed || panGesture.state == UIGestureRecognizerStateCancelled) {
        
        if (_timeHighlight.lowerThumbHighlight || _timeHighlight.upperThumbHighlight) {
            if ([self.delegate respondsToSelector:@selector(ysTimeSelector:onChangeFromTime:toTime:)]) {
                [self.delegate ysTimeSelector:self onChangeFromTime:_fromTime toTime:_toTime];
            }
        }
        
        _timeHighlight.lowerThumbHighlight = NO;
        _timeHighlight.upperThumbHighlight = NO;
    }
}

#pragma mark - Helper Methods
- (void)setFromTimeFromTouch:(CGPoint)point
{
    // check touch point is nearest to which line indicator
    YSTimeLineIndicator *lineIndicator = [self getClosestLineIndicatorToPoint:point];
    
    YSTime *lineTime = lineIndicator.time;
    
    if ([lineTime isEqualToTime:_toTime] || [lineTime isBiggerThanTime:_toTime]) return;
    
    _fromTime = [[YSTime alloc] initWith24HourFormat:lineTime.hour minute:lineTime.minute];
}

- (void)setToTimeFromTouch:(CGPoint)point
{
    // check touch point is nearest to which line indicator
    YSTimeLineIndicator *lineIndicator = [self getClosestLineIndicatorToPoint:point];
    
    YSTime *lineTime = lineIndicator.time;
    
    if ([lineTime isEqualToTime:_fromTime] || [_fromTime isBiggerThanTime:lineTime]) return;
    
    _toTime = [[YSTime alloc] initWith24HourFormat:lineTime.hour minute:lineTime.minute];
}

- (YSTimeLineIndicator *)getClosestLineIndicatorToPoint:(CGPoint)point
{
    YSTimeLineIndicator *nearestLineIndicator = [_lineIndicators firstObject];
    for (NSInteger i = 1; i < [_lineIndicators count]; i++) {
        YSTimeLineIndicator *currentLineIndicator = [_lineIndicators objectAtIndex:i];
        
        CGPoint nearestLinePoint = nearestLineIndicator.frame.origin;
        CGPoint currentLinePoint = currentLineIndicator.frame.origin;
        
        double nearestLineToTouchPointDistance = [self distanceForPoint:nearestLinePoint toPoint:point];
        double currentLineToTouchPointDistance = [self distanceForPoint:currentLinePoint toPoint:point];
        
        if (currentLineToTouchPointDistance < nearestLineToTouchPointDistance) {
            nearestLineIndicator = currentLineIndicator;
        }
    }
    
    return nearestLineIndicator;
}

- (double)distanceForPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint
{
    double dx = tPoint.x - fPoint.x;
    double dy = tPoint.y - fPoint.y;
    double distance = sqrt(dx*dx + dy*dy);
    
    return distance;
}

- (NSInteger)getLabelNeededToDraw
{
    NSInteger diffHours = _maxTimeRange.hour - _minTimeRange.hour;
    
    NSInteger maxMinute = kMaxMinutePerHour;
    
    return (NSInteger)((diffHours * maxMinute) / _divideByMinutes) + 1;
}

// example if the part minute is 30, the possible value it generates is
// 0, 30, 60
// so if the given minute to convert is 38, it will find the nearest and turn to that
// which 38 to nearest 30
// e.g. part minute is 15
// possible values: 0, 15, 30, 45, 60
// 38 will = 45
- (NSInteger)convertMinuteToNearestPart:(NSInteger)partMinute theMinute:(NSInteger)theMinute
{
    NSInteger maxMinute = kMaxMinutePerHour;
    NSMutableArray *possibleValues = [NSMutableArray array];
    NSInteger currentMinute = 0;
    while (currentMinute <= maxMinute) {
        [possibleValues addObject:[NSNumber numberWithInteger:currentMinute]];
        
        currentMinute += partMinute;
    }
    
    // find the one nearest to minute given
    NSInteger nearestToTheMinute = [[possibleValues firstObject] integerValue];
    for (NSInteger i = 1; i < possibleValues.count; i++) {
        NSInteger currMinute = [[possibleValues objectAtIndex:i] integerValue];
        
        NSInteger nearestMinuteDiffTheMinute = labs(nearestToTheMinute - theMinute);
        NSInteger currMinuteDiffTheMinute = labs(currMinute - theMinute);
        
        if (currMinuteDiffTheMinute < nearestMinuteDiffTheMinute) {
            nearestToTheMinute = currMinute;
        }
    }
    
    return nearestToTheMinute;
}

#pragma mark - Public Methods
- (void)setFromTime:(YSTime *)fromTime toTime:(YSTime *)toTime scrollTo:(BOOL)needScroll
{
    // Filter minute before assignemnt
    NSInteger fromTimeMinute = [self convertMinuteToNearestPart:_divideByMinutes theMinute:fromTime.minute];
    NSInteger toTimeMinute = [self convertMinuteToNearestPart:_divideByMinutes theMinute:toTime.minute];
    
    _fromTime = [[YSTime alloc] initWith24HourFormat:fromTime.hour minute:fromTimeMinute];
    _toTime = [[YSTime alloc] initWith24HourFormat:toTime.hour minute:toTimeMinute];
    
    // redraw
    [self redrawTime];
    
    if (needScroll) {
        // scroll to position
        for (YSTimeLineIndicator *line in _lineIndicators) {
            if ([_fromTime isEqualToTime:line.time]) {
                [_timeScroller setContentOffset:CGPointMake(line.frame.origin.x - kWidthPer30Minute, 0) animated:YES];
            }
        }
    }
}

@end
