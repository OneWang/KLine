//
//  KLineModel.h
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KLineGroupModel;
@interface KLineModel : NSObject

///前一个 model
@property (nonatomic, strong) KLineModel *previousKLineModel;

///父 modelArray: 用来给当前 model 索引到 parent 数组
@property (nonatomic, strong) KLineGroupModel *parentGroupModel;

///该 model 及其之前所有收盘价之和
@property (nonatomic, strong) NSNumber *sumOfLastClose;

///该 model 及其之前所有成交量之和
@property (nonatomic, strong) NSNumber *sumOfLastVolume;

///日期
@property (nonatomic, copy) NSString *date;

/** 开收高低 */
@property (nonatomic, strong) NSNumber *open;
@property (nonatomic, strong) NSNumber *close;
@property (nonatomic, strong) NSNumber *high;
@property (nonatomic, strong) NSNumber *low;

///成交量
@property (nonatomic, assign) CGFloat volume;

///是否是某个月的第一个交易日
@property (nonatomic, assign) BOOL isFirstTradeDate;

//初始化Model
- (void) initWithArray:(NSArray *)arr;

//初始化第一条数据
- (void) initFirstModel;

//初始化其他数据
- (void)initData;

@end
