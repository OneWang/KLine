//
//  Kline.m
//  KLine
//
//  Created by Jack on 2017/3/2.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "Kline.h"

@interface Kline ()

@property (nonatomic, assign) CGContextRef context;

/**
 *  最后一个绘制日期点
 */
@property (nonatomic, assign) CGPoint lastDrawDatePoint;

@end

@implementation Kline

- (instancetype)initWithContext:(CGContextRef)context{
    if (self = [super init]) {
        
        self.context = context;
        self.lastDrawDatePoint = CGPointZero;
    }
    return self;
}

- (UIColor *)draw{
    if (!self.kLineModel || !self.context || !self.kLinePositionModel) {
        return nil;
    }
    CGContextRef context = self.context;
    
    //设置画笔的颜色
    UIColor *strokeColor = self.kLinePositionModel.OpenPoint.y < self.kLinePositionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    //画中间较宽的开盘线段-实体线
    CGContextSetLineWidth(context, [StockConstantVariable kLineWidth]);
    const CGPoint solidPoints[] = {self.kLinePositionModel.OpenPoint, self.kLinePositionModel.ClosePoint};
    //划线
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上下影线
    CGContextSetLineWidth(context, StockChartShadowLineWidth);
    const CGPoint shadowPoints[] = {self.kLinePositionModel.HighPoint, self.kLinePositionModel.LowPoint};
    //画线
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    //日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.kLineModel.date.doubleValue/1000];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    
    CGPoint drawDatePoint = CGPointMake(self.kLinePositionModel.LowPoint.x + 1, self.maxY + 1.5);
    if (CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || drawDatePoint.x - self.lastDrawDatePoint.x > 60) {
        ///辅助文字
        [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11] , NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        self.lastDrawDatePoint = drawDatePoint;
    }
    return strokeColor;
}

@end
