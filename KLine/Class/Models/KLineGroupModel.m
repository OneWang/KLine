//
//  KLineGroupModel.m
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KLineGroupModel.h"
#import "KLineModel.h"

@implementation KLineGroupModel

+ (instancetype)objectWithArray:(NSArray *)arr{
    NSAssert([arr isKindOfClass:[NSArray class]], @"array 不是一个数组");
    
    KLineGroupModel *groupModel = [KLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block KLineModel *preModel = [[KLineModel alloc] init];
    
    //设置数据
    for (NSArray *valueArr in arr) {
        KLineModel *model = [KLineModel new];
        model.previousKLineModel = preModel;
        [model initWithArray:valueArr];
        model.parentGroupModel = groupModel;
        
        [mutableArr addObject:model];
        preModel = model;
    }
    
    groupModel.models = mutableArr;
    
    //初始化第一个 model 的数据
    KLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他 model 的数据
    [mutableArr enumerateObjectsUsingBlock:^(KLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initData];
    }];
    
    return groupModel;
}

@end
