//
//  ATVideoSourceProtocol.h
//  ATPlayer
//
//  Created by ApesTalk on 2018/8/27.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//  播放数据源模型必须遵守的协议

#import <Foundation/Foundation.h>

@protocol ATVideoSourceProtocol <NSObject>
@required
@property (nonatomic, strong, nonnull) NSURL *sourceUrl;///< remote url or local file url

@optional
@property (nonatomic, copy, nullable) NSString *sourceId;
@property (nonatomic, copy, nullable) NSString *souceName;
@end
