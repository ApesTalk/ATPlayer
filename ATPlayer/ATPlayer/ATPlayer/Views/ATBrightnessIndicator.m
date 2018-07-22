//
//  ATBrightnessIndicator.m
//  ATPlayer
//
//  Created by lumin on 2018/7/21.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "ATBrightnessIndicator.h"
#import "ATIndicatorProgressView.h"

static ATBrightnessIndicator *shareIndicator;
@interface ATBrightnessIndicator ()
@property (nonatomic, strong) ATIndicatorProgressView *progressView;
@end

@implementation ATBrightnessIndicator
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:CGRectMake(0, 0, 156, 156)]){
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"亮度";
        if (@available(iOS 8.2, *)) {
            _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        } else {
            _titleLabel.font = [UIFont systemFontOfSize:16];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(12, 12, 156-24, 21);
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((156-80)*0.5, (156-80)*0.5, 80, 80)];
        _imageView.image = [UIImage imageNamed:@"at_brightness"];
        [self addSubview:_imageView];
        
        _progressView = [[ATIndicatorProgressView alloc]initWithFrame:CGRectMake(12, 156-12-8, 156-24, 8)];
        [self addSubview:_progressView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progressView.progress = progress;
}

#pragma mark---KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    CGFloat brightness = [[change objectForKey:NSKeyValueChangeNewKey]floatValue];
    [self setProgress:brightness];
    [[self class]show];
}

+ (instancetype)shareIndicator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIndicator = [[self alloc]init];
    });
    return shareIndicator;
}

+ (void)show
{
    ATBrightnessIndicator *indicator = [self shareIndicator];
    if(!indicator.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                indicator.center = window.center;
                [window addSubview:indicator];
                break;
            }
        }
    }
    indicator.layer.opaque = 1.0;
    [indicator.layer removeAnimationForKey:@"opacityAnimation"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    animation.repeatCount = 1;
    animation.duration = 2;
    [indicator.layer addAnimation:animation forKey:@"opacityAnimation"];
}

+ (void)orientationChanged
{
    if(shareIndicator && shareIndicator.superview){
        shareIndicator.center = shareIndicator.superview.center;
    }
}

+ (void)startMonitoring
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [[UIScreen mainScreen]addObserver:[self shareIndicator] forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
}

+ (void)stopMonitoring
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIScreen mainScreen]removeObserver:[self shareIndicator] forKeyPath:@"brightness"];
}

@end
