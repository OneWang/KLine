//
//  StockConstant.h
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StockConstant.h"

@interface StockConstantVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth;

+ (void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap;

+ (void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio;
+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio;
+ (void)setkLineVolumeViewRadio:(CGFloat)radio;

/**
 *  isEMA线
 */
+ (CGFloat)isEMALine;
+ (void)setisEMALine:(StockChartTargetLineStatus)type;


@end
