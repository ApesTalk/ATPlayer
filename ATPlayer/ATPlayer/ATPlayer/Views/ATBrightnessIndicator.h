//
//  ATBrightnessIndicator.h
//  ATPlayer
//
//  Created by ApesTalk on 2018/7/21.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//  亮度指示器

#import <UIKit/UIKit.h>

@interface ATBrightnessIndicator : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setProgress:(CGFloat)progress;
+ (instancetype)shareIndicator;
+ (void)show;
+ (void)startMonitoring;
+ (void)stopMonitoring;

@end
