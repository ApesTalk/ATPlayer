//
//  ATIndicatorProgressView.m
//  ATPlayer
//
//  Created by lumin on 2018/7/21.
//  Copyright © 2018年 https://github.com/ApesTalk. All rights reserved.
//

#import "ATIndicatorProgressView.h"

@implementation ATIndicatorProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.00];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGFloat lineWidth = CGRectGetHeight(self.bounds) - 2;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat dotLength = (CGRectGetWidth(self.bounds)-17)/16.f;//最多16个白色方块
    CGFloat lengths[] = {dotLength,1};//绘制dotLength个点，跳过1个点。依次循环
    //parse=0 phase参数表示在第一个虚线绘制的时候跳过多少个点  count=2，是lengthes数组的长度
    CGContextSetLineDash(context, 0, lengths, 2);
    //从x=1开始绘制
    CGContextMoveToPoint(context, 1, CGRectGetMidY(self.bounds));
    NSInteger dotCount = round(16*_progress);
    NSLog(@"progress=%f, count=%li",_progress,dotCount);
    CGContextAddLineToPoint(context, 1+(dotLength+1)*dotCount, CGRectGetMidY(self.bounds));
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MIN(1.0, MAX(0.0, progress));
    [self setNeedsDisplay];
}

@end
