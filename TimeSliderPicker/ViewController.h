//
//  ViewController.h
//  TimeSliderPicker
//
//  Created by Tan YongSheng on 09/01/2017.
//  Copyright © 2017 Imagine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTimeSelector.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet YSTimeSelector *timeSelector;

@end

