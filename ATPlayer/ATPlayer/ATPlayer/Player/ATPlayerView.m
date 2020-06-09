//
//  ATPlayerView.m
//  ATPlayer
//
//  Created by ApesTalk on 2018/8/5.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "ATPlayerView.h"
#import <AVKit/AVKit.h>
#import "NSObject+SafeKVO.h"

static NSString *kATStatusKey = @"status";
static NSString *kATRateKey = @"rate";
static NSString *kATLoadedTimeRangesKey = @"loadedTimeRanges";


@interface ATPlayerView()<UIGestureRecognizerDelegate>
{
    struct {
        BOOL readyToPlay;
        BOOL bufferChanged;
        BOOL timeChanged;
        BOOL playFinished;
        BOOL happendedError;
    }_delegateResponse;
}

@property (nonatomic, strong) AVPlayerLayer *currentPlayerLayer;
@property (nonatomic, strong) AVPlayerLayer *nextPlayerLayer;

@end

@implementation ATPlayerView
- (void)dealloc
{
    NSLog(@"player is dealloced");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor blackColor];
        _videoCoverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_videoCoverView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];

    }
    return self;
}

- (void)setDelegate:(id<ATPlayerViewDelegate>)delegate
{
    _delegate = delegate;
    _delegateResponse.readyToPlay = [_delegate respondsToSelector:@selector(readyToPlay:)];
    _delegateResponse.bufferChanged = [_delegate respondsToSelector:@selector(player:bufferTimeChanged:totalTime:)];
    _delegateResponse.timeChanged = [_delegate respondsToSelector:@selector(player:timeChanged:totalTime:)];
    _delegateResponse.playFinished = [_delegate respondsToSelector:@selector(playFinished:)];
    _delegateResponse.happendedError = [_delegate respondsToSelector:@selector(player:happendedError:error:)];
}

- (void)playWithModel:(id<ATVideoSourceProtocol>)model
{
    if(!model){
        return;
    }
    
    //release old
    if(_currentPlayerLayer){
        [self removeObserverForItem:_currentPlayerLayer.player.currentItem];
        [_currentPlayerLayer.player pause];
    }
    if(_nextPlayerLayer){
        [self removeObserverForItem:_nextPlayerLayer.player.currentItem];
        [_nextPlayerLayer.player pause];
    }
    //create new
    
    BOOL isFileUrl = model.sourceUrl.isFileURL;
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:model.sourceUrl];
    [self addObserverForItem:item];
    
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
    self.currentPlayerLayer.frame = self.bounds;
    [self.layer addSublayer:self.currentPlayerLayer];
    [self.currentPlayerLayer.player play];
    
    [self addObserverForPlayer:self.currentPlayerLayer.player];
}

- (void)seekToTime:(long long )time compelete:(void (^)(void))compelete
{
    if(self.currentPlayerLayer.player.currentItem.status == AVPlayerStatusReadyToPlay){
        [self.currentPlayerLayer.player seekToTime:CMTimeMake(time, 1) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000) completionHandler:^(BOOL finished) {
            !compelete ?: compelete();
        }];
    }
}

- (void)pause
{
    if(_currentPlayerLayer){
        [_currentPlayerLayer.player pause];
    }
    if(_nextPlayerLayer){
        [_nextPlayerLayer.player pause];
    }
    //TODO:update ui
}

- (void)destory
{
    if(_currentPlayerLayer){
        [self removeObserverForItem:_currentPlayerLayer.player.currentItem];
        [_currentPlayerLayer.player pause];
        [_currentPlayerLayer.player cancelPendingPrerolls];
        [_currentPlayerLayer.player.currentItem cancelPendingSeeks];
        [_currentPlayerLayer.player.currentItem.asset cancelLoading];
        [_currentPlayerLayer.player replaceCurrentItemWithPlayerItem:nil];
        _currentPlayerLayer.player = nil;
    }
    if(_nextPlayerLayer){
        [self removeObserverForItem:_nextPlayerLayer.player.currentItem];
        [_nextPlayerLayer.player pause];
        [_nextPlayerLayer.player cancelPendingPrerolls];
        [_nextPlayerLayer.player.currentItem cancelPendingSeeks];
        [_nextPlayerLayer.player.currentItem.asset cancelLoading];
        [_nextPlayerLayer.player replaceCurrentItemWithPlayerItem:nil];
        _nextPlayerLayer.player = nil;
    }
}

- (void)addObserverForPlayer:(AVPlayer *)player
{
    //给播放器添加进度更新
    __weak typeof(player) weakPlayer = player;
    //每秒更新一次进度
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //这行放在Block外面会导致切换视频后获取的总时长是上个视频的
        AVPlayerItem *item = weakPlayer.currentItem;
        Float64 current = CMTimeGetSeconds(time);
        Float64 total = CMTimeGetSeconds(item.duration);
        NSLog(@"已经播放了%.2fs. progress=%.2f", current, current/total);
        !self->_delegateResponse.timeChanged ?: [self->_delegate player:self timeChanged:current totalTime:total];
//        weakSelf.currentTimeLabel.text = [weakSelf timeStrFromCMTime:time];
//        [weakSelf.progressView setProgress:current/total animated:YES];
//        [weakSelf.slider setValue:current/total animated:YES];
    }];
    [player at_addObserver:self forKeyPath:kATRateKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForPlayer:(AVPlayer *)player
{
    [player at_removeObserver:self forKeyPath:kATRateKey context:nil];
}

- (void)addObserverForItem:(AVPlayerItem *)item
{
    if(item){
        [item at_addObserver:self forKeyPath:kATStatusKey options:NSKeyValueObservingOptionNew context:nil];
        [item at_addObserver:self forKeyPath:kATLoadedTimeRangesKey options:NSKeyValueObservingOptionNew context:nil];
        //给AVPlayerItem添加播放完成通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    }
}

- (void)removeObserverForItem:(AVPlayerItem *)item
{
    if(item){
        [item at_removeObserver:self forKeyPath:kATStatusKey];
        [item at_removeObserver:self forKeyPath:kATLoadedTimeRangesKey];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem *)object;
    if([keyPath isEqualToString:kATStatusKey]){
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if(status == AVPlayerStatusReadyToPlay){
            !_delegateResponse.readyToPlay ?: [_delegate readyToPlay:self];
            NSLog(@"正在播放。。。视频总长度：%.2f",CMTimeGetSeconds(item.duration));
//            _durationLabel.text = [self timeStrFromCMTime:item.duration];
        }else if (status == AVPlayerStatusUnknown){
            NSLog(@"未知状态");
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"加载失败:%@", self.currentPlayerLayer.player.error);
            !_delegateResponse.happendedError ?: [_delegate player:self happendedError:ATPlayerErrorTypePlayFailed error:self.currentPlayerLayer.player.error];
        }
    }else if ([keyPath isEqualToString:kATLoadedTimeRangesKey]){
        NSArray *array = item.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        Float64 totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        Float64 total = CMTimeGetSeconds(item.duration);
        !_delegateResponse.bufferChanged ?: [_delegate player:self bufferTimeChanged:totalBuffer totalTime:total];
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)playFinished:(NSNotification *)notification
{
    NSLog(@"视频播放完成");
    !_delegateResponse.playFinished ?: [_delegate playFinished:self];
}

#pragma mark---UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return touch.view == self;
}

- (void)singleTapAction:(UITapGestureRecognizer *)ges
{
    
}

- (void)doubleTapAction:(UITapGestureRecognizer *)ges
{
    
}
@end
