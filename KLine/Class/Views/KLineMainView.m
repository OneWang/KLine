//
//  KLineMainView.m
//  KLine
//
//  Created by Jack on 2017/3/6.
//  Copyright © 2017年 Jack. All rights reserved.
//  主K线图

#import "KLineMainView.h"
#import "KLineModel.h"
#import "Kline.h"
#import <Masonry.h>
#import "StockConstant.h"
#import "StockConstantVariable.h"
#import "UIColor+StockColor.h"

@interface KLineMainView ()

///需要绘制的 model 数组
@property (nonatomic, strong) NSMutableArray<KLineModel *> *needDrawKLineModels;

///需要绘制的 model 位置数组
@property (nonatomic, strong) NSMutableArray *needDrawKLinePositionModels;

///index 开始的 X 的值
@property (nonatomic, assign) NSInteger startXPosition;

///旧的 contentoffset 值
@property (nonatomic, assign) CGFloat oldContentOffsetX;

///旧的缩放值
@property (nonatomic, assign) CGFloat oldScale;

@end

@implementation KLineMainView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.oldScale = 0;
        self.oldContentOffsetX = 0;
        self.needDrawStartIndex = 0;
    }
    return self;
    
}

#pragma mark - 绘图相关的方法
#pragma mark - drawRect 方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //如果数组为空,则不进行绘制,直接设置本 view 为背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.kLineModels) {
        CGContextClearRect(context, rect);
        //所有图标的背景颜色
        CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
        CGContextFillRect(context, rect);
        return;
    }
    
    //设置 view 的背景颜色
    NSMutableArray *kLineColors = @[].mutableCopy;
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
    CGContextFillRect(context, rect);
    
    //设置显示日期的区域背景颜色
    CGContextSetFillColorWithColor(context, [UIColor assistBackgroundColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15));
    
    //画线
    if (self.mainViewType == StockChartcenterViewTypeKline) {
        Kline *kLine = [[Kline alloc] initWithContext:context];
        kLine.maxY = StockChartKLineMainViewMaxY;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(KLinePositionModel *  _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLine.kLinePositionModel = kLinePositionModel;
            kLine.kLineModel = self.needDrawKLineModels[idx];
            UIColor *kLineColor = [kLine draw];
            [kLineColors addObject:kLineColor];
        }];
    }else{
        __block NSMutableArray *positions = @[].mutableCopy;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(KLinePositionModel *  _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *strokeColor = positionModel.OpenPoint.y < positionModel.ClosePoint.y ? [UIColor redColor] : [UIColor greenColor];
            [kLineColors addObject:strokeColor];
            [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
        }];
        
        __block CGPoint lastDrawDatePoint = CGPointZero;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(KLinePositionModel *  _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = [positions[idx] CGPointValue];
            //日期
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.needDrawKLineModels[idx].date.doubleValue/1000];
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"HH:mm";
            NSString *dateStr = [formatter stringFromDate:date];
            
            CGPoint drawDatePoint = CGPointMake(point.x + 1, StockChartKLineMainViewMaxY + 1.5);
            if (CGPointEqualToPoint(lastDrawDatePoint, CGPointZero) || point.x - lastDrawDatePoint.x > 60) {
                [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11] , NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
                lastDrawDatePoint = drawDatePoint;
            }
        }];
    }
    
    if (self.delegate && kLineColors.count > 0) {
        if ([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineColors:)]) {
            [self.delegate kLineMainViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
}

#pragma mark - 公有方法
#pragma mark 重新设置相关数据,然后重绘
- (void)drawMainView{
    NSAssert(self.kLineModels, @"kLineModels不能为空");
    
    //提取需要的kLineModel
    [self private_extractNeedDrawModels];
    
    //转换 model 为坐标 model
    [self private_convertToKLinePositionModelWithKLineModels];
    
    //间接调用 drawReact 方法
    [self setNeedsDisplay];
}


/**
 更新 MainView 的宽度
 */
- (void)updateMainViewWidth{
    //根据 stockModels 的个数和间隔和 K 线的宽度计算出 self 的宽度,并设置 contentsize
    CGFloat kLineViewWidth = self.kLineModels.count * [StockConstantVariable kLineWidth] + (self.kLineModels.count + 1) * [StockConstantVariable kLineGap] + 10;
    
    if (kLineViewWidth < self.parentScrollView.bounds.size.width) {
        kLineViewWidth = self.parentScrollView.bounds.size.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
    }];
    
    [self layoutIfNeeded];
    
    //更新 scrollview 的 contentsize
    self.parentScrollView.contentSize = CGSizeMake(kLineViewWidth, self.parentScrollView.contentSize.height);
}


/**
 长按的时候根据原始的 X 位置获得精确的 X 的位置

 @param originXPosition 原始位置
 @return 精确位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition{
    CGFloat xPositionInMainView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositionInMainView - self.startXPosition)/([StockConstantVariable kLineGap] + [StockConstantVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        CGFloat minX = kLinePositionModel.HighPoint.x - ([StockConstantVariable kLineGap] + [StockConstantVariable kLineWidth] / 2);
        CGFloat maxX = kLinePositionModel.HighPoint.x + ([StockConstantVariable kLineGap] + [StockConstantVariable kLineWidth] / 2);
        if (xPositionInMainView > minX && xPositionInMainView < maxX) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)]) {
                [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            return kLinePositionModel.HighPoint.x;
        }
    }
    return 0.0f;
}

#pragma mark - 私有方法
- (NSArray *)private_extractNeedDrawModels{
    //K 线图的默认间距为1,默认宽度为20
    CGFloat lineGap = [StockConstantVariable kLineGap];
    CGFloat lineWidth = [StockConstantVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap + lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex;
    
    if (self.pinchStartIndex > 0) {
        needDrawKLineStartIndex = self.pinchStartIndex;
        _needDrawStartIndex = self.pinchStartIndex;
        self.pinchStartIndex = -1;
    }else{
        needDrawKLineStartIndex = self.needDrawStartIndex;
    }
    
    NSLog(@"这是模型开始的 index --------%lu",needDrawKLineStartIndex);
    [self.needDrawKLineModels removeAllObjects];
    
    //赋值数组
    if (needDrawKLineStartIndex < self.kLineModels.count) {
        if (needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count) {
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        }else{
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineModels:)]) {
        [self.delegate kLineMainViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
    }
    
    return self.needDrawKLineModels;
}

#pragma mark - 将model 转换为 position 模型
- (NSArray *)private_convertToKLinePositionModelWithKLineModels{
    if (!self.needDrawKLineModels) {
        return nil;
    }
    
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    KLineModel *firstModel = kLineModels.firstObject;
    __block CGFloat minAssert = firstModel.low.floatValue;
    __block CGFloat maxAssert = firstModel.high.floatValue;
    
    [kLineModels enumerateObjectsUsingBlock:^(KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (kLineModel.high.floatValue > maxAssert) {
            maxAssert = kLineModel.high.floatValue;
        }
        if (kLineModel.low.floatValue < minAssert) {
            minAssert = kLineModel.low.floatValue;
        }
    }];
    
    maxAssert *= 1.0001;
    minAssert *= 0.9991;
    
    CGFloat minY = StockChartKLineMainViewMinY;
    CGFloat maxY = self.parentScrollView.frame.size.height * [StockConstantVariable kLineMainViewRadio] - 15;
    
    CGFloat unitValue = (maxAssert - minAssert) / (maxY - minY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    
    NSInteger kLineModelCount = kLineModels.count;
    for (NSInteger idx = 0; idx < kLineModelCount; ++ idx) {
        //K 线坐标转换
        KLineModel *kLineModel = kLineModels[idx];
        CGFloat xPosition = self.startXPosition + idx * ([StockConstantVariable kLineWidth] + [StockConstantVariable kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.open.floatValue - minAssert) / unitValue));
        CGFloat closePointY = ABS(maxY - (kLineModel.close.floatValue - minAssert)/unitValue);
        if (ABS(closePointY - openPoint.y) < StockChartKLineMinWidth) {
            if (openPoint.y > closePointY) {
                openPoint.y = closePointY + StockChartKLineMinWidth;
            }else if (openPoint.y < closePointY){
                closePointY = openPoint.y + StockChartKLineMinWidth;
            }else{
                if (idx > 0) {
                    KLineModel *preKLineModel = kLineModels[idx - 1];
                    if (kLineModel.open.floatValue > preKLineModel.close.floatValue) {
                        openPoint.y = closePointY + StockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + StockChartKLineMinWidth;
                    }
                }else if(idx + 1 < kLineModelCount){
                    //idx==0即第一个
                    KLineModel *subKLineModel = kLineModels[idx + 1];
                    if (kLineModel.close.floatValue < subKLineModel.open.floatValue) {
                        openPoint.y = closePointY + StockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + StockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.high .floatValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.low.floatValue - minAssert)/unitValue));
        
        KLinePositionModel *kLinePositionModel = [KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
        
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineMainViewCurrentMaxPrice:minPrice:)]) {
            [self.delegate kLineMainViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if ([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLinePositionModels:)]) {
            [self.delegate kLineMainViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    
    return self.needDrawKLinePositionModels;
}

#pragma mark - 添加所有事件监听的方法
static char *observerContext = NULL;
- (void)private_addAllEventListener{
    //KVO 监听 scrollview 的状态变化
    [_parentScrollView addObserver:self forKeyPath:StockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:StockChartContentOffsetKey]) {
        CGFloat difValue = ABS(self.parentScrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= [StockConstantVariable kLineWidth] + [StockConstantVariable kLineGap]) {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawMainView];
        }
    }
}

#pragma mark - 系统方法
#pragma mark - 已经添加到父 view 的方法,设置父 scrollview
- (void)didMoveToSuperview{
    _parentScrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListener];
    [super didMoveToSuperview];
}

#pragma mark - setter and getter
- (NSInteger)startXPosition{
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount + 1) * [StockConstantVariable kLineGap] + leftArrCount * [StockConstantVariable kLineWidth] + [StockConstantVariable kLineWidth] / 2;
    return startXPosition;
}

- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffestX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffestX - [StockConstantVariable kLineGap]) / ([StockConstantVariable kLineGap] + [StockConstantVariable kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

- (void)setKLineModels:(NSArray *)kLineModels{
    _kLineModels = kLineModels;
    [self updateMainViewWidth];
}

- (NSMutableArray<KLineModel *> *)needDrawKLineModels{
    if (!_needDrawKLineModels) {
        _needDrawKLineModels = [NSMutableArray array];
    }
    return _needDrawKLineModels;
}

- (NSMutableArray *)needDrawKLinePositionModels{
    if (!_needDrawKLinePositionModels) {
        _needDrawKLinePositionModels = [NSMutableArray array];
    }
    return _needDrawKLinePositionModels;
}

- (void)removeAllObserver{
    [_parentScrollView removeObserver:self forKeyPath:@"contentOffset" context:observerContext];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
