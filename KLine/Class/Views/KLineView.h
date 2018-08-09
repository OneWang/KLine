//
//  KLineView.h
//  KLine
//
//  Created by Jack on 2017/3/6.
//  Copyright © 2017年 Jack. All rights reserved.
//  所有线图的view(K线图;交易量;长按view)

#import <UIKit/UIKit.h>

@class KLineModel;
@interface KLineView : UIView

///主 view 所占比例
@property (nonatomic, assign) CGFloat mainViewRatio;
///成交量 view 所占比例
@property (nonatomic, assign) CGFloat volumeViewRatio;
///数据
@property (nonatomic, strong) NSArray<KLineModel *> *kLineModels;
///K 线类型
@property (nonatomic, assign) StockChartCenterViewType mainViewType;
///Accessory 指标类型
@property (nonatomic, assign) StockChartTargetLineStatus targetLineStatus;

/**
 重绘
 */
- (void)reDraw;

@end
