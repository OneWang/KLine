//
//  KLineModel.m
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KLineModel.h"
#import "KLineGroupModel.h"

@implementation KLineModel

- (void)initWithArray:(NSArray *)arr{
    NSAssert(arr.count == 6, @"数组长度不足");
    if (self) {
        self.date = arr[0];
        self.open = @([arr[1] floatValue]);
        self.high = @([arr[2] floatValue]);
        self.low = @([arr[3] floatValue]);
        self.close = @([arr[4] floatValue]);
        
        self.volume = [arr[5] floatValue];
        self.sumOfLastClose = @(self.close.floatValue + self.previousKLineModel.sumOfLastClose.floatValue);
        self.sumOfLastVolume = @(self.volume + self.previousKLineModel.sumOfLastVolume.floatValue);
    }
}

//对Model数组进行排序，初始化每个Model的最新9Clock的最低价和最高价
- (void)rangeLastNinePriceByArray:(NSArray<KLineModel *> *)models condition:(NSComparisonResult)condition{
    switch (condition) {
            //最高价
        case NSOrderedAscending:
        {
            for (NSInteger j = 7; j >= 1; j--) {
                
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)initFirstModel{
//    _NineClocksMinPrice = _Low;
//    _NineClocksMaxPrice = _High;
//    [self DIF];
//    [self DEA];
//    [self MACD];
//    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
//    [self rangeLastNinePriceByArray:self.parentGroupModel.models condition:NSOrderedDescending];
//    [self RSV_9];
//    [self KDJ_K];
//    [self KDJ_D];
//    [self KDJ_J];
}

- (void)initData{
    
}

@end
