//
//  ATPlayerView.m
//  ATPlayer
//
//  Created by lumin on 2018/8/5.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "ATPlayerView.h"
#import <AVKit/AVKit.h>

static NSString *kStatusKey = @"status";
static NSString *kLoadedTimeRangesKey = @"loadedTimeRanges";


@interface ATPlayerView()
@property (nonatomic, strong) AVPlayerLayer *currentPlayerLayer;
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
    }
    return self;
}

- (void)addProgressObserver
{
    //给播放器添加进度更新
    __weak typeof(self) weakSelf = self;
    //每秒更新一次进度
    [self.currentPlayerLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //这行放在Block外面会导致切换视频后获取的总时长是上个视频的
        AVPlayerItem *item = weakSelf.currentPlayerLayer.player.currentItem;
        Float64 current = CMTimeGetSeconds(time);
        Float64 total = CMTimeGetSeconds(item.duration);
        NSLog(@"已经播放了%.2fs. progress=%.2f", current, current/total);
//        weakSelf.currentTimeLabel.text = [weakSelf timeStrFromCMTime:time];
//        [weakSelf.progressView setProgress:current/total animated:YES];
//        [weakSelf.slider setValue:current/total animated:YES];
    }];
}

- (void)addObserverForItem:(AVPlayerItem *)item
{
    if(item){
        [item addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionNew context:nil];
        [item addObserver:self forKeyPath:kLoadedTimeRangesKey options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserverForItem:(AVPlayerItem *)item
{
    if(item){
        [item removeObserver:self forKeyPath:kStatusKey];
        [item removeObserver:self forKeyPath:kLoadedTimeRangesKey];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem *)object;
    if([keyPath isEqualToString:kStatusKey]){
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if(status == AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放。。。视频总长度：%.2f",CMTimeGetSeconds(item.duration));
//            _durationLabel.text = [self timeStrFromCMTime:item.duration];
        }else if (status == AVPlayerStatusUnknown){
            NSLog(@"未知状态");
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"加载失败:%@", self.currentPlayerLayer.player.error);
        }
    }else if ([keyPath isEqualToString:kLoadedTimeRangesKey]){
        NSArray *array = item.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbacckFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerLayer.player.currentItem];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)playbacckFinished:(NSNotification *)notification
{
    NSLog(@"视频播放完成");
//    [self nextClick];
}

- (void)playWithModel:(id<ATProtocols>)model
{
    if(!model){
        return;
    }
    //release old
    if(_currentPlayerLayer){
        [self removeObserverForItem:_currentPlayerLayer.player.currentItem];
        [_currentPlayerLayer.player pause];
        [self removeNotification];
    }
    //create new
    
    BOOL isFileUrl = model.lineUrl.isFileURL;
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:model.lineUrl];
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
    self.currentPlayerLayer.frame = self.bounds;
    [self.layer addSublayer:self.currentPlayerLayer];
    [self.currentPlayerLayer.player play];
}

@end
