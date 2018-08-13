//
//  TestViewController.m
//  ATPlayer
//
//  Created by lumin on 2018/8/12.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "TestViewController.h"
#import "ATPlayerView.h"

@interface TestViewController ()
@property (nonatomic, strong) ATPlayerView *playerView;
@end

@implementation TestViewController
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"title";
    _playerView = [[ATPlayerView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width*9.0/16.0)];
    [self.view addSubview:_playerView];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"3" ofType:@"mp4"];
    [_playerView playWithUrl:[NSURL fileURLWithPath:path]];
}

@end
