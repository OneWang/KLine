//
//  KLinePositionModel.h
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLinePositionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint OpenPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint ClosePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint HighPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint LowPoint;

/**
 *  工厂方法
 */
+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint;

@end
