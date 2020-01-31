/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNDateTimePicker.h"

#import <React/RCTUtils.h>
#import <React/UIView+React.h>

@interface RNDateTimePicker ()

@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, assign) NSInteger reactMinuteInterval;
@property (nonatomic, strong) UIColor *reactLabelColor;

@end

@implementation RNDateTimePicker

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self addTarget:self action:@selector(didChange)
               forControlEvents:UIControlEventValueChanged];
    _reactMinuteInterval = 1;
  }
  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (void)didChange
{
  if (_onChange) {
    _onChange(@{ @"timestamp": @(self.date.timeIntervalSince1970 * 1000.0) });
  }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
  [super setDatePickerMode:datePickerMode];
  // We need to set minuteInterval after setting datePickerMode, otherwise minuteInterval is invalid in time mode.
  self.minuteInterval = _reactMinuteInterval;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval
{
  [super setMinuteInterval:minuteInterval];
  _reactMinuteInterval = minuteInterval;
}

- (void)setLabelColor:(UIColor *)color {
  [self setTintColor:color];
  [self setValue:color forKey:@"textColor"];
  
  if ([self respondsToSelector:sel_registerName("setHighlightsToday:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(setHighlightsToday:) withObject:[NSNumber numberWithBool:NO]];
#pragma clang diagnostic pop
    _reactLabelColor = color;
  }
}

- (UIColor *)getLabelColor {
  return self.reactLabelColor;
}

@end
