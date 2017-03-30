//
//  Kline.h
//  KLine
//
//  Created by Jack on 2017/3/2.
//  Copyright © 2017年 Jack. All rights reserved.
//  画蜡烛线

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "KLinePositionModel.h"

@interface Kline : NSObject

///K 线的 model
@property (nonatomic, strong) KLineModel *kLineModel;
///K 线的位置 model
@property (nonatomic, strong) KLinePositionModel *kLinePositionModel;
/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制K线
 */
- (UIColor *)draw;

@end
