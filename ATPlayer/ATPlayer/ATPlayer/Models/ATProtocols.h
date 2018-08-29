//
//  ATProtocols.h
//  ATPlayer
//
//  Created by lumin on 2018/8/27.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//  播放数据源模型必须遵守的协议

#import <Foundation/Foundation.h>

@protocol ATProtocols <NSObject>
@property (nonatomic, copy) NSString *lineId;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, strong) NSURL *lineUrl;
@end
