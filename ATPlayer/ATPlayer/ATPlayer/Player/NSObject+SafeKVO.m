//
//  NSObject+SafeKVO.m
//  ATPlayer
//
//  Created by ApesTalk on 2020/6/7.
//  Copyright © 2020 https://github.com/ApesTalk. All rights reserved.
//

#import "NSObject+SafeKVO.h"

static NSMutableDictionary *_observInfos;

@implementation NSObject (SafeKVO)
- (NSMutableDictionary *)observInfos
{
    if(!_observInfos){
        _observInfos = [NSMutableDictionary dictionary];
    }
    return _observInfos;
}

- (void)at_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if([self.observInfos objectForKey:keyPath] == observer){
        return;
    }
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)at_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if([self.observInfos objectForKey:keyPath] != observer){
        return;
    }
    [self removeObserver:observer forKeyPath:keyPath];
}

- (void)at_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if([self.observInfos objectForKey:keyPath] != observer){
        return;
    }
    [self removeObserver:observer forKeyPath:keyPath context:context];
}
@end
