//
//  KLinePositionModel.m
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KLinePositionModel.h"
#import <UIKit/UIKit.h>

@implementation KLinePositionModel

+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint
{
    KLinePositionModel *model = [KLinePositionModel new];
    model.OpenPoint = openPoint;
    model.ClosePoint = closePoint;
    model.HighPoint = highPoint;
    model.LowPoint = lowPoint;
    return model;
}

@end
