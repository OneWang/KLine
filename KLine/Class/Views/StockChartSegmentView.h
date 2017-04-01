//
//  StockChartSegmentView.h
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//  按钮点击view

#import <UIKit/UIKit.h>

@class StockChartSegmentView;
@protocol StockChartSegmentViewDelegate <NSObject>

@optional
- (void)stockChartSegmentView:(StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;

@end

@interface StockChartSegmentView : UIView

@property (nonatomic, strong) NSArray *items;

///
@property (nonatomic, weak) id<StockChartSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithItems:(NSArray *)items;

@end
