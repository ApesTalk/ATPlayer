//
//  ATPlayerView.h
//  ATPlayer
//
//  Created by lumin on 2018/8/5.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATProtocols.h"

@interface ATPlayerView : UIView
@property (nonatomic, strong) UIImageView *videoCoverView;///< 视频封面，暴露出来方便自行选择用哪个图片加载库
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;

- (void)playWithModel:(id<ATProtocols>)model;

@end
