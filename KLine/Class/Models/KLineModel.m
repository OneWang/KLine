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

#pragma mark - setter and getter
- (NSNumber *)MA7{
    if (!_MA7) {
        if ([StockConstantVariable isEMALine] == StockChartTargetLineStatusMA) {
            if (!_MA7) {
                NSInteger index = [self.parentGroupModel.models indexOfObject:self];
                if (index >= 6) {
                    if (index > 6) {
                        _MA7 = @((self.sumOfLastClose.floatValue - self.parentGroupModel.models[index - 7].sumOfLastClose.floatValue) / 7);
                    }else{
                        _MA7 = @(self.sumOfLastClose.floatValue / 7);
                    }
                }
            }
        }else{
            return self.EMA7;
        }
    }
    return _MA7;
}

- (NSNumber *)MA30{
    if (!_MA30) {
        if ([StockConstantVariable isEMALine] == StockChartTargetLineStatusMA) {
            if (!_MA30) {
                NSInteger index = [self.parentGroupModel.models indexOfObject:self];
                if (index >= 29) {
                    if (index > 29) {
                        _MA30 = @((self.sumOfLastClose.floatValue - self.parentGroupModel.models[index - 30].sumOfLastClose.floatValue) / 30);
                    }else{
                        _MA30 = @(self.sumOfLastClose.floatValue / 30);
                    }
                }
            }
        }else{
            return self.EMA30;
        }
    }
    return _MA30;
}

//// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
- (NSNumber *)EMA7
{
    if(!_EMA7) {
        _EMA7 = @((self.close.floatValue + 3 * self.previousKLineModel.EMA7.floatValue)/4);
    }
    return _EMA7;
}

- (NSNumber *)EMA30
{
    if(!_EMA30) {
        _EMA30 = @((2 * self.close.floatValue + 29 * self.previousKLineModel.EMA30.floatValue)/31);
    }
    return _EMA30;
}


@end
