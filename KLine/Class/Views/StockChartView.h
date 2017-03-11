//
//  StockChartView.h
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockConstant.h"

//种类
typedef NS_ENUM(NSInteger, KLineType) {
    KLineTypeTimeShare = 1,
    KLineType1Min,
    KLineType3MIn,
    KLineType5Min,
    KLineType10Min,
    KLineType15Min,
    KLineType30Min,
    KLineType1Hour,
    KLineType2Hour,
    KLineType4Hour,
    KLineType6Hour,
    KLineType12Hour,
    KLineType1Day,
    KLineType3Day,
    KLineType1Week
};

@protocol StockChartViewDataSouce <NSObject>

- (id)stockDatasWithIndex:(NSInteger)index;

@end

@interface StockChartView : UIView

///
@property (nonatomic, weak) id<StockChartViewDataSouce> dataSource;

///当前选中的索引
@property (nonatomic, assign, readonly) KLineType currentLineTypeIndex;

@property (nonatomic, strong) NSArray *itemModels;

- (void)reloadData;

@end

@interface StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) StockChartCenterViewType centerViewType;

+ (instancetype)itemModelWithTitle:(NSString *)title type:(StockChartCenterViewType)type;

@end
