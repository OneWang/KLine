//
//  KLineMAView.m
//  KLine
//
//  Created by LI on 2017/3/31.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KLineMAView.h"
#import "KLineModel.h"

@interface KLineMAView ()

///时间
@property (weak, nonatomic) UILabel *dateDescLabel;
///开盘
@property (weak, nonatomic) UILabel *openDescLabel;
///昨收
@property (weak, nonatomic) UILabel *closeDescLabel;
///最高
@property (weak, nonatomic) UILabel *highDescLabel;
///最低
@property (weak, nonatomic) UILabel *lowDescLabel;

@property (weak, nonatomic) UILabel *MA7Label;
@property (weak, nonatomic) UILabel *MA30Label;
@end

@implementation KLineMAView

+ (instancetype)MAView{
    KLineMAView *MAView = [[KLineMAView alloc] init];
    return MAView;
}

- (instancetype)init{
    if (self = [super init]) {
        
        UILabel *date = [self createLabel];
        date.textColor = [UIColor whiteColor];
        self.dateDescLabel = date;
        
        UILabel *open = [self createLabel];
        open.textColor = [UIColor whiteColor];
        self.openDescLabel = open;
        
        UILabel *close = [self createLabel];
        close.textColor = [UIColor whiteColor];
        self.closeDescLabel = close;
        
        UILabel *hight = [self createLabel];
        hight.textColor = [UIColor whiteColor];
        self.highDescLabel = hight;
        
        UILabel *low = [self createLabel];
        low.textColor = [UIColor whiteColor];
        self.lowDescLabel = low;
        
        UILabel *ma7 = [self createLabel];
        self.MA7Label = ma7;
        ma7.textColor = [UIColor ma7Color];
        
        UILabel *ma30 = [self createLabel];
        self.MA30Label = ma30;
        ma30.textColor = [UIColor ma30Color];
        
        UILabel *openLabel = [self createLabel];
        openLabel.text = @" 开盘:";
        UILabel *closeLabel = [self createLabel];
        closeLabel.text = @" 收盘";
        UILabel *hightLabel = [self createLabel];
        hightLabel.text = @" 最高:";
        UILabel *lowLabel = [self createLabel];
        lowLabel.text = @" 最低:";
        
        [date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
        }];
        
        [openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(date.mas_right).offset(10);
        }];
        
        [open mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(openLabel.mas_right);
        }];
        
        [closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(open.mas_right).offset(10);
        }];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(closeLabel.mas_right);
        }];
        
        [hightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(close.mas_right).offset(10);
        }];
        
        [hight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(hightLabel.mas_right);
        }];
        
        [lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(hight.mas_right).offset(10);
        }];
        
        [low mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(lowLabel.mas_right);
        }];
        
        [ma7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(low.mas_right).offset(10);
            make.top.bottom.equalTo(self);
        }];
        
        [ma30 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(ma7.mas_right).offset(10);
        }];
    }
    return self;
}

- (void)maProfileWithModel:(KLineModel *)model{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.date.doubleValue/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-DD HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    
    self.dateDescLabel.text = [@"  " stringByAppendingString:dateStr];
    
    self.openDescLabel.text = [NSString stringWithFormat:@"%.2f",model.open.floatValue];
    self.highDescLabel.text = [NSString stringWithFormat:@"%.2f",model.high.floatValue];
    self.lowDescLabel.text = [NSString stringWithFormat:@"%.2f",model.low.floatValue];
    self.closeDescLabel.text = [NSString stringWithFormat:@"%.2f",model.close.floatValue];

    self.MA7Label.text = [NSString stringWithFormat:@" MA7：%.2f ",model.MA7.floatValue];
    self.MA30Label.text = [NSString stringWithFormat:@" MA30：%.2f",model.MA30.floatValue];
}

#pragma mark - private mtehod
- (UILabel *)createLabel{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end
