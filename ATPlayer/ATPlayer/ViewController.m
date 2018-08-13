//
//  ViewController.m
//  ATPlayer
//
//  Created by lumin on 2018/7/21.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "ViewController.h"
#import "ATBrightnessIndicator.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TestViewController.h"

@interface ViewController ()
@property (nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ATBrightnessIndicator startMonitoring];
//    self.navigationItem.leftBarButtonItem
//    self.navigationItem.leftBarButtonItems
//    self.navigationItem.rightBarButtonItem
//    self.navigationItem.rightBarButtonItems
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestViewController *vc = [[TestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    
    //修改屏幕亮度
    CGFloat brightness = [UIScreen mainScreen].brightness;
    brightness += 0.1;
    if(brightness > 1.0){
        brightness = 0.0;
    }
    [[UIScreen mainScreen]setBrightness:brightness];
    
    //iOS7之前的修改音量的方式
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//    mpc.volume = 0.5;
    //iOS7之后使用MPVolumeView
    CGFloat value = [[self volumeSlider] value] + 0.1;
    if(value > 1.0){
        value = 0.0;
    }
    [self setVolume:value];
}

- (void)setVolume:(float)value {
    UISlider *volumeSlider = [self volumeSlider];
    self.volumeView.showsVolumeSlider = YES; // 需要设置 showsVolumeSlider 为 YES
    [volumeSlider setValue:value animated:NO];
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _volumeView.center = window.center;
        _volumeView.hidden = YES;
        [window addSubview:_volumeView];
    }
    return _volumeView;
}

- (UISlider *)volumeSlider {
    UISlider* volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            break;
        }
    }
    return volumeSlider;
}
@end
