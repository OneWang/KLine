//
//  KLineView.m
//  KLine
//
//  Created by Jack on 2017/3/6.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KLineView.h"
#import "KLineMainView.h"   ///主K线图(蜡烛图)
#import "KlineLongPress.h"  ///长按view

#import "KLineMAView.h"     ///顶部的开收高低view

@interface KLineView ()<UIScrollViewDelegate,KLineMainViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  主K线图
 */
@property (nonatomic, strong) KLineMainView *kLineMainView;

/**
 *  长按后显示的 view
 */
@property (nonatomic, strong) KlineLongPress *longPressView;

/**
 *  K线图顶部的view
 */
@property (strong, nonatomic) KLineMAView *kLineMAView;

@property (nonatomic, strong) MASConstraint *kLineMainViewHeightConstraint;

@end

@implementation KLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.mainViewRatio = 0.98;
        self.volumeViewRatio = 0.2;
    }
    return self;
}

#pragma mark - KLineMainViewDelegate
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels{

}

- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels{

}

- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors{
    
}

- (void)kLineMainViewLongPressKLinePositionModel:(KLinePositionModel *)kLinePositionModel kLineModel:(KLineModel *)kLineModel{
    self.longPressView.selectedPositionModel = kLinePositionModel;
    self.longPressView.selectedModel = kLineModel;
    [self.longPressView setNeedsDisplay];
    
    [self.kLineMAView maProfileWithModel:kLineModel];
}

#pragma mark - setter and getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self).offset(-48);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (void)setKLineModels:(NSArray<KLineModel *> *)kLineModels{
    if (!kLineModels) {
        return;
    }
    _kLineModels = kLineModels;
    
    [self private_drawKLineMainView];
    //设置 contentoffset
    CGFloat kLineViewWidth = self.kLineModels.count * [StockConstantVariable kLineWidth] + (self.kLineModels.count + 1) * [StockConstantVariable kLineGap] + 10;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    if (offset > 0) {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    KLineModel *model = kLineModels.lastObject;
    [self.kLineMAView maProfileWithModel:model];
}

#pragma mark - event事件处理方法
#pragma mark 缩放执行方法
- (void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > StockChartScaleFactor) {
        CGFloat oldKLineWidth = [StockConstantVariable kLineWidth];
        NSInteger oldNeedDrawStartIndex = self.kLineMainView.needDrawStartIndex;
        NSLog(@"原来的 index %ld",self.kLineMainView.needDrawStartIndex);
        
        [StockConstantVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + StockChartScaleFactor) : (1 - StockChartScaleFactor))];
        oldScale = pinch.scale;
        //更新 MainView 的宽度
        [self.kLineMainView updateMainViewWidth];
        
        if (pinch.numberOfTouches == 2) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x + p2.x)/2, (p1.y + p2.y)/2);
            NSUInteger oldLeftAttCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [StockConstantVariable kLineGap]) / ([StockConstantVariable kLineGap] + oldKLineWidth);
            NSUInteger newleftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [StockConstantVariable kLineGap]) / ([StockConstantVariable kLineGap] + [StockConstantVariable kLineWidth]);
            self.kLineMainView.pinchStartIndex = oldNeedDrawStartIndex + oldLeftAttCount - newleftArrCount;
            NSLog(@"计算得出的 index %lu",self.kLineMainView.pinchStartIndex);
        }
        [self.kLineMainView drawMainView];
    }
}

#pragma mark - 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    static CGFloat oldPositionX = 0;
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self.scrollView];
        if (ABS(oldPositionX - location.x) < ([StockConstantVariable kLineWidth] + [StockConstantVariable kLineGap]) / 2) {
            return;
        }
        
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        //初始化长按 view
        if (!self.longPressView) {
            _longPressView = [KlineLongPress new];
            _longPressView.backgroundColor = [UIColor clearColor];
            [self addSubview:_longPressView];
            [_longPressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }else{
            self.longPressView.hidden = YES;
        }
        //更新竖线位置
        [self.kLineMainView getExactXPositionWithOriginXPosition:location.x];
        self.longPressView.stockScrollView = self.scrollView;
        self.longPressView.hidden = NO;
    }
    
    if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed) {
        
        oldPositionX = 0;
        //恢复 scrollview 的滑动
        self.scrollView.scrollEnabled = YES;
        [self setNeedsDisplay];
        self.longPressView.hidden = YES;
        KLineModel *lastModel = self.kLineModels.lastObject;
        [self.kLineMAView maProfileWithModel:lastModel];
    }
}

#pragma mark - 重绘
- (void)reDraw{
    self.kLineMainView.mainViewType = self.mainViewType;
    if (self.targetLineStatus >= 103) {
//        self.kLineMainView
    }
    [self.kLineMainView drawMainView];
}

#pragma mark - 私有方法
#pragma mark - 画 KLineMainView
- (void)private_drawKLineMainView{
    self.kLineMainView.kLineModels = self.kLineModels;
    [self.kLineMainView drawMainView];
}

- (void)dealloc{
    [self.kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter and getter
- (KLineMAView *)kLineMAView{
    if (!_kLineMAView) {
        _kLineMAView = [[KLineMAView alloc] init];
        [self addSubview:_kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(10);
            make.top.equalTo(self).offset(5);
        }];
    }
    return _kLineMAView;
}

- (KLineMainView *)kLineMainView{
    if (!_kLineMainView && self) {
        _kLineMainView = [KLineMainView new];
        _kLineMainView.delegate = self;
        [self.scrollView addSubview:_kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(5);
            make.left.equalTo(self.scrollView);
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(@0);
        }];
    }
    return _kLineMainView;
}


@end
