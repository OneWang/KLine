//
//  StockChartView.m
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "StockChartView.h"
#import "KLineView.h"
#import <Masonry.h>
#import "StockConstantVariable.h"
#import "StockChartSegmentView.h"

@interface StockChartView ()<StockChartSegmentViewDelegate>

///K 线图
@property (nonatomic, strong) KLineView *kLineView;

///K 线图类型
@property (nonatomic, assign) StockChartCenterViewType currentCenterViewType;

///底部选择 view
@property (nonatomic, strong) StockChartSegmentView *segmentView;

///当前索引
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation StockChartView

#pragma mark - StockChartSegmentViewDelegate
- (void)stockChartSegmentView:(StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index{
    self.currentIndex = index;
    if (index >= 100) {
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
    }else{
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
            id stockData = [self.dataSource stockDatasWithIndex:index];
            
            if (!stockData) {
                return;
            }
            
            StockChartViewItemModel *itemModel = self.itemModels[index];
            StockChartCenterViewType type = itemModel.centerViewType;
            if (type != self.currentCenterViewType) {
                //移除当前的 view, 设置新的 view
                self.currentCenterViewType = type;
                switch (type) {
                    case StockChartcenterViewTypeKline:
                        self.kLineView.hidden = NO;
                        [self bringSubviewToFront:self.segmentView];
                        break;
                        
                    default:
                        break;
                }
            }
            
            if (type == StockChartcenterViewTypeOther) {
                
            }else{
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.mainViewType = type;
                [self.kLineView reDraw];
            }
            [self bringSubviewToFront:self.segmentView];
        }
    }
}

#pragma mark - setter and getter
- (KLineView *)kLineView{
    if (!_kLineView) {
        _kLineView = [[KLineView alloc] init];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self);
            make.left.equalTo(self.segmentView.mas_right);
        }];
    }
    return _kLineView;
}

- (StockChartSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [StockChartSegmentView new];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self);
            make.width.equalTo(@50);
        }];
    }
    return _segmentView;
}

- (void)setItemModels:(NSArray *)itemModels{
    _itemModels = itemModels;
    if (itemModels) {
        NSMutableArray *items = [NSMutableArray array];
        for (StockChartViewItemModel *item in itemModels) {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if (self.dataSource) {
        self.segmentView.selectedIndex = 4;
    }
}

- (void)setDataSource:(id<StockChartViewDataSouce>)dataSource{
    _dataSource = dataSource;
    if (self.itemModels) {
        self.segmentView.selectedIndex = 4;
    }
}

- (void)reloadData{
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}

@end

@implementation StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(StockChartCenterViewType)type{
    StockChartViewItemModel *itemModel = [StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
