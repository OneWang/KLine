//
//  StockConstant.h
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#ifndef StockConstant_h
#define StockConstant_h


#endif /* StockConstant_h */

/**
 *  K线图需要加载更多数据的通知
 */
#define StockChartKLineNeedLoadMoreDataNotification @"StockChartKLineNeedLoadMoreDataNotification"

/**
 *  K线图Y的View的宽度
 */
#define StockChartKLinePriceViewWidth 47

/**
 *  K线图的X的View的高度
 */
#define StockChartKLineTimeViewHeight 20

/**
 *  K线最大的宽度
 */
#define StockChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define StockChartKLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define StockChartScaleBound 0.03

/**
 *  K线的缩放因子
 */
#define StockChartScaleFactor 0.03

/**
 *  UIScrollView的contentOffset属性
 */
#define StockChartContentOffsetKey @"contentOffset"

/**
 *  时分线的宽度
 */
#define StockChartTimeLineLineWidth 0.5

/**
 *  时分线图的Above上最小的X
 */
#define StockChartTimeLineMainViewMinX 0.0

/**
 *  分时线的timeLabelView的高度
 */
#define StockChartTimeLineTimeLabelViewHeight 19

/**
 *  时分线的成交量的线宽
 */
#define StockChartTimeLineVolumeLineWidth 0.5

/**
 *  长按时的线的宽度
 */
#define StockChartLongPressVerticalViewWidth 0.5

/**
 *  MA线的宽度
 */
#define StockChartMALineWidth 0.8

/**
 *  上下影线宽度
 */
#define StockChartShadowLineWidth 1
/**
 *  所有profileView的高度
 */
#define StockChartProfileViewHeight 50

/**
 *  K线图上可画区域最小的Y
 */
#define StockChartKLineMainViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define StockChartKLineMainViewMaxY (self.frame.size.height - 15)

/**
 *  K线图的成交量上最小的Y
 */
#define StockChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define StockChartKLineVolumeViewMaxY (self.frame.size.height)

/**
 *  K线图的副图上最小的Y
 */
#define StockChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define StockChartKLineAccessoryViewMaxY (self.frame.size.height)

/**
 *  K线图的副图中间的Y
 */
//#define  StockChartKLineAccessoryViewMiddleY (self.frame.size.height-20)/2.f + 20
#define StockChartKLineAccessoryViewMiddleY (maxY - (0.f-minValue)/unitValue)

/**
 *  时分线图的Above上最小的Y
 */
#define StockChartTimeLineMainViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define StockChartTimeLineMainViewMaxY (self.frame.size.height - StockChartTimeLineTimeLabelViewHeight)


/**
 *  时分线图的Above上最大的Y
 */
#define StockChartTimeLineMainViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define StockChartTimeLineVolumeViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define StockChartTimeLineVolumeViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define StockChartTimeLineVolumeViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define StockChartTimeLineVolumeViewMinX 0

//Kline种类
typedef NS_ENUM(NSInteger, StockChartCenterViewType) {
    StockChartcenterViewTypeKline= 1, //K线
    StockChartcenterViewTypeTimeLine,  //分时图
    StockChartcenterViewTypeOther
};

//Accessory指标种类
typedef NS_ENUM(NSInteger,  StockChartTargetLineStatus) {
    StockChartTargetLineStatusMACD = 100,    //MACD线
    StockChartTargetLineStatusKDJ,    //KDJ线
    StockChartTargetLineStatusAccessoryClose,    //关闭Accessory线
    StockChartTargetLineStatusMA , //MA线
    StockChartTargetLineStatusEMA,  //EMA线
    StockChartTargetLineStatusCloseMA  //MA关闭线
    
};
