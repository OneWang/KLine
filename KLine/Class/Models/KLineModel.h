//
//  KLineModel.h
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//  K线图数据模型

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

#pragma 内部自动初始化
//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N

//MA（7）=（C1+C2+……CN）/7
@property (nonatomic, copy) NSNumber *MA7;

//MA（30）=（C1+C2+……CN）/30
@property (nonatomic, copy) NSNumber *MA30;

#pragma 第一个EMA等于MA；即EMA(n) = MA(n)

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA7;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA30;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA12;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA26;

//初始化Model
- (void)initWithArray:(NSArray *)arr;

//初始化第一条数据
- (void)initFirstModel;

//初始化其他数据
- (void)initData;

@end
