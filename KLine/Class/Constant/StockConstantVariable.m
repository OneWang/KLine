//
//  StockConstant.m
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "StockConstantVariable.h"
#import "StockConstant.h"
#import <UIKit/UIKit.h>

/**
 *  K线图的宽度，默认20
 */
static CGFloat StockChartKLineWidth = 2;

/**
 *  K线图的间隔，默认1
 */
static CGFloat StockChartKLineGap = 1;


/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat StockChartKLineMainViewRadio = 0.98;

/**
 *  VolumeView的高度占比,默认为0.5
 */
static CGFloat StockChartKLineVolumeViewRadio = 0.2;


/**
 *  是否为EMA线
 */
static StockChartTargetLineStatus StockChartKLineIsEMALine = StockChartTargetLineStatusMA;


@implementation StockConstantVariable

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth{
    return StockChartKLineWidth;
}

+ (void)setkLineWith:(CGFloat)kLineWidth{
    if (kLineWidth > StockChartKLineMaxWidth) {
        kLineWidth = StockChartKLineMaxWidth;
    }else if (kLineWidth < StockChartKLineMinWidth){
        kLineWidth = StockChartKLineMinWidth;
    }
    StockChartKLineWidth = kLineWidth;
}


/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap{
    return StockChartKLineGap;
}

+ (void)setkLineGap:(CGFloat)kLineGap{
    StockChartKLineGap = kLineGap;
}

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio{
    return StockChartKLineMainViewRadio;
}

+ (void)setkLineMainViewRadio:(CGFloat)radio{
    StockChartKLineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio{
    return StockChartKLineVolumeViewRadio;
}

+ (void)setkLineVolumeViewRadio:(CGFloat)radio{
    StockChartKLineVolumeViewRadio = radio;
}

/**
 *  isEMA线
 */

+ (CGFloat)isEMALine{
    return StockChartKLineIsEMALine;
}

+ (void)setisEMALine:(StockChartTargetLineStatus)type{
    StockChartKLineIsEMALine = type;
}

@end
