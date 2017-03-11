//
//  KLineGroupModel.h
//  KLine
//
//  Created by Jack on 2017/3/3.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLineModel;

@interface KLineGroupModel : NSObject

@property (nonatomic, strong) NSArray<KLineModel *> *models;

//初始化Model
+ (instancetype) objectWithArray:(NSArray *)arr;

@end
