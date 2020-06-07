//
//  ATVideoSourceModel.h
//  ATPlayer
//
//  Created by lumin on 2018/8/29.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVideoSourceProtocol.h"

@interface ATVideoSourceModel : NSObject <ATVideoSourceProtocol>
@property (nonatomic, strong) NSURL *sourceUrl;

@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *sourceName;
@end
