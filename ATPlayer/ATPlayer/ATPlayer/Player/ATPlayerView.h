//
//  ATPlayerView.h
//  ATPlayer
//
//  Created by ApesTalk on 2018/8/5.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATVideoSourceProtocol.h"

typedef NS_ENUM(NSUInteger, ATPlayerErrorType) {
    ATPlayerErrorTypeUnknow,
    ATPlayerErrorTypeSourceUrlEmpty,
    ATPlayerErrorTypePlayFailed,
};

@class ATPlayerView;
@protocol ATPlayerViewDelegate <NSObject>
- (void)readyToPlay:(ATPlayerView *)player;
- (void)player:(ATPlayerView *)player bufferTimeChanged:(double)currentTime totalTime:(double)totalTime;
- (void)player:(ATPlayerView *)player timeChanged:(double)currentTime totalTime:(double)totalTime;
- (void)playFinished:(ATPlayerView *)player;

- (void)player:(ATPlayerView *)player happendedError:(ATPlayerErrorType)type error:(NSError *)error;
@end


@interface ATPlayerView : UIView
//ui
@property (nonatomic, strong) UIImageView *videoCoverView;///< 视频封面，暴露出来方便自行选择用哪个图片加载库
@property (nonatomic, strong) UIButton *centerPlayBtn;
@property (nonatomic, strong) UIView *portraitTopBar;///< default xxx , resetable
@property (nonatomic, strong) UIView *portraitBottomBar;///< default xxx , resetable
@property (nonatomic, strong) UIView *landscapeTopBar;///< default xxx , resetable
@property (nonatomic, strong) UIView *landscapeBottomBar;///< default xxx , resetable

@property (nonatomic, weak) id<ATPlayerViewDelegate> delegate;

- (void)playWithModel:(id<ATVideoSourceProtocol>)model;
- (void)seekToTime:(long long )time compelete:(void(^)(void))compelete;
- (void)pause;
- (void)destory;
@end
