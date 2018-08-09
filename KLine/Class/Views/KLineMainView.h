//
//  KLineMainView.h
//  KLine
//
//  Created by Jack on 2017/3/6.
//  Copyright © 2017年 Jack. All rights reserved.
//  主K线图(蜡烛图的view)

#import <UIKit/UIKit.h>

@class KLinePositionModel,KLineModel;
@protocol KLineMainViewDelegate <NSObject>

@optional
///长按显示手指按着的KLinePositionModel和KLineModel
- (void)kLineMainViewLongPressKLinePositionModel:(KLinePositionModel *)kLinePositionModel kLineModel:(KLineModel *)kLineModel;

///当前 mainview 的最大值和最小值
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

///当前需要绘制的 K 线模型数组
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

///当前需要绘制的 K 线 位置模型数组
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;

///当前需要绘制的 K 线颜色数组
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors;

@end

@interface KLineMainView : UIView

///模型数组
@property (nonatomic, strong) NSArray *kLineModels;
///父 scrollview
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;
///类型
@property (nonatomic, assign) StockChartCenterViewType mainViewType;
///需要绘制 index 开始值
@property (nonatomic, assign) NSInteger needDrawStartIndex;
///捏合点
@property (nonatomic, assign) NSInteger pinchStartIndex;
///代理
@property (nonatomic, weak) id<KLineMainViewDelegate> delegate;

///画 mainview 的所有线
- (void)drawMainView;

///更新 mainview 的宽度
- (void)updateMainViewWidth;

///长按的时候根据原始的 X 位置获得精确的 X 的位置
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition;

///移除所有的监听事件
- (void)removeAllObserver;

@end
