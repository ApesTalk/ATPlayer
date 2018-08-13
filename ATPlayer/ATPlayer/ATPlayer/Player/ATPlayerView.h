//
//  ATPlayerView.h
//  ATPlayer
//
//  Created by lumin on 2018/8/5.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATPlayerView : UIView
@property (nonatomic, strong) UIImageView *videoCoverView;///< 视频封面

- (void)playWithUrl:(NSURL *)url;
@end
