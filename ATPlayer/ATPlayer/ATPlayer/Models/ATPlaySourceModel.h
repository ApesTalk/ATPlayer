//
//  ATPlaySourceModel.h
//  ATPlayer
//
//  Created by lumin on 2018/8/29.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATProtocols.h"

@interface ATPlaySourceModel : NSObject <ATProtocols>
@property (nonatomic, copy) NSString *lineId;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, strong) NSURL *lineUrl;
@end
