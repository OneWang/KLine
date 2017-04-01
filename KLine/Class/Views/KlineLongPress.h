//
//  KlineLongPress.h
//  KLine
//
//  Created by Jack on 2017/3/8.
//  Copyright © 2017年 Jack. All rights reserved.
//  长按之后显示的view

#import <UIKit/UIKit.h>
#import "KLinePositionModel.h"
#import "KLineModel.h"

@interface KlineLongPress : UIView

///当前长按选中的位置 model
@property (nonatomic, strong) KLinePositionModel *selectedPositionModel;

///当前长按选中的 model
@property (nonatomic, strong) KLineModel *selectedModel;

///当前滑动的 scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

@end
