//
//  StockChartSegmentView.m
//  KLine
//
//  Created by Jack on 2017/3/7.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "StockChartSegmentView.h"

static NSInteger const StockChartSegmentStartTag = 2000;

@interface StockChartSegmentView ()

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIButton *secondLevelSelectedBtn1;

@property (nonatomic, strong) UIButton *secondLevelSelectedBtn2;

@end

@implementation StockChartSegmentView

- (instancetype)initWithItems:(NSArray *)items{
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
    }
    return self;
}

#pragma mark - setter and getter
- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor assistBackgroundColor];
        
        NSArray *titleArray = @[@"MACD",@"KDJ",@"关闭",@"MA",@"EMA",@"关闭"];
        __block UIButton *preBtn;
        [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = StockChartSegmentStartTag + 100 + idx;
            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [self.indicatorView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.indicatorView).multipliedBy(1.0f/titleArray.count);
                make.width.equalTo(self.indicatorView);
                make.left.equalTo(self.indicatorView);
                if(preBtn){
                    make.top.equalTo(preBtn.mas_bottom);
                } else {
                    make.top.equalTo(self.indicatorView);
                }
            }];
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
            [self.indicatorView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            preBtn = btn;
        }];
        
        UIButton *firstBtn = _indicatorView.subviews[0];
        [firstBtn setSelected:YES];
        _secondLevelSelectedBtn1 = firstBtn;
        UIButton *firstBtn2 = _indicatorView.subviews[6];
        [firstBtn2 setSelected:YES];
        _secondLevelSelectedBtn2 = firstBtn2;
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
            make.right.equalTo(self.mas_left);
        }];
    }
    return _indicatorView;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    if (items.count == 0 || !items) {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    
    for (NSString *title in items) {
        UIButton *btn = [self private_createButtonWithTitle:title tag:StockChartSegmentStartTag+index];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67/255.f alpha:1];
        [self addSubview:btn];
        [self addSubview:view];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self).multipliedBy(1.0f/count);
            make.width.equalTo(self);
            if(preBtn){
                make.top.equalTo(preBtn.mas_bottom).offset(0.5);
            } else {
                make.top.equalTo(self);
            }
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(btn);
            make.top.equalTo(btn.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        preBtn = btn;
        index++;
    }
}

#pragma mark 设置底部按钮index
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:StockChartSegmentStartTag + selectedIndex];
    NSAssert(btn, @"按钮初始化出错");
    [self event_segmentButtonClicked:btn];
}

- (void)setSelectedBtn:(UIButton *)selectedBtn{
    if(_selectedBtn == selectedBtn){
        if(selectedBtn.tag != StockChartSegmentStartTag){
            return;
        } else {
            
        }
    }
    
    if(selectedBtn.tag >= 2100 && selectedBtn.tag < 2103){
        [_secondLevelSelectedBtn1 setSelected:NO];
        [selectedBtn setSelected:YES];
        _secondLevelSelectedBtn1 = selectedBtn;
    } else if(selectedBtn.tag >= 2103) {
        [_secondLevelSelectedBtn2 setSelected:NO];
        [selectedBtn setSelected:YES];
        _secondLevelSelectedBtn2 = selectedBtn;
    } else if(selectedBtn.tag != StockChartSegmentStartTag){
        [_selectedBtn setSelected:NO];
        [selectedBtn setSelected:YES];
        _selectedBtn = selectedBtn;
    }
    
    _selectedIndex = selectedBtn.tag - StockChartSegmentStartTag;
    
    if(_selectedIndex == 0 && self.indicatorView.frame.origin.x < 0){
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
        }];
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.right.equalTo(self.mas_left);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
        }];
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    }
    [self layoutIfNeeded];
}

#pragma mark - 私有方法
#pragma mark 创建底部按钮
- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor ma30Color] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

#pragma mark 底部按钮点击事件
- (void)event_segmentButtonClicked:(UIButton *)btn{
    self.selectedBtn = btn;
    
    if(btn.tag == StockChartSegmentStartTag){
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(stockChartSegmentView:clickSegmentButtonIndex:)]){
        [self.delegate stockChartSegmentView:self clickSegmentButtonIndex: btn.tag - StockChartSegmentStartTag];
    }
}

@end
