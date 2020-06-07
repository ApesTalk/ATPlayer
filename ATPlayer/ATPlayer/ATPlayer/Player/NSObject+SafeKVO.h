//
//  NSObject+SafeKVO.h
//  ATPlayer
//
//  Created by lumin on 2020/6/7.
//  Copyright © 2020 https://github.com/ApesTalk. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSObject (SafeKVO)
- (void)at_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)at_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)at_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;
@end


