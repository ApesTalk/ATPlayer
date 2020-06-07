//
//  TestViewController.m
//  ATPlayer
//
//  Created by lumin on 2018/8/12.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "TestViewController.h"
#import "ATPlayerView.h"
#import "ATVideoSourceModel.h"

@interface TestViewController ()<ATPlayerViewDelegate>
@property (nonatomic, strong) ATPlayerView *playerView;
@end

@implementation TestViewController
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试本地播放";
    
    UIBarButtonItem *b1 = [[UIBarButtonItem alloc]initWithTitle:@"测试1" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b2 = [[UIBarButtonItem alloc]initWithTitle:@"测试2" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b3 = [[UIBarButtonItem alloc]initWithTitle:@"测试3" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b4 = [[UIBarButtonItem alloc]initWithTitle:@"测试4" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b5 = [[UIBarButtonItem alloc]initWithTitle:@"测试5" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b6 = [[UIBarButtonItem alloc]initWithTitle:@"测试6" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[b1, b2, b3, b4, b5, b6];
    
    UIBarButtonItem *b7 = [[UIBarButtonItem alloc]initWithTitle:@"测试7" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b8 = [[UIBarButtonItem alloc]initWithTitle:@"测试8" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b9 = [[UIBarButtonItem alloc]initWithTitle:@"测试9" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b10 = [[UIBarButtonItem alloc]initWithTitle:@"测试10" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b11 = [[UIBarButtonItem alloc]initWithTitle:@"测试11" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *b12 = [[UIBarButtonItem alloc]initWithTitle:@"测试12" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItems = @[b7, b8, b9, b10, b11, b12];
    self.view.backgroundColor = [UIColor whiteColor];

    _playerView = [[ATPlayerView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width*9.0/16.0)];
    _playerView.delegate = self;
    [self.view addSubview:_playerView];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"TINKbyMrKaplin" ofType:@"mp4"];
    ATVideoSourceModel *model = [[ATVideoSourceModel alloc]init];
    model.sourceId = @"123456";
    model.sourceName = @"标准";
    model.sourceUrl = [NSURL fileURLWithPath:path];
    [_playerView playWithModel:model];
}

#pragma mark---ATPlayerViewDelegate
- (void)readyToPlay:(ATPlayerView *)player
{
    [player seekToTime:5 compelete:^{
        
    }];
}

- (void)playFinished:(ATPlayerView *)player
{
    
}

- (void)player:(ATPlayerView *)player bufferTimeChanged:(double)currentTime totalTime:(double)totalTime
{
    
}

- (void)player:(ATPlayerView *)player timeChanged:(double)currentTime totalTime:(double)totalTime
{
    
}

- (void)player:(ATPlayerView *)player happendedError:(ATPlayerErrorType)type error:(NSError *)error
{
    
}

@end
