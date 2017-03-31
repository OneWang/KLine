//
//  KLineMAView.h
//  KLine
//
//  Created by LI on 2017/3/31.
//  Copyright © 2017年 Jack. All rights reserved.
//  K线图上部的开收高低和时间view以及均线值

#import <UIKit/UIKit.h>

@class KLineModel;
@interface KLineMAView : UIView

+ (instancetype)MAView;

- (void)maProfileWithModel:(KLineModel *)model;

@end
