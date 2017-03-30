//
//  ViewController.m
//  KLine
//
//  Created by Jack on 2017/3/2.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "KLineGroupModel.h"
#import "StockChartView.h"
#import "UIColor+StockColor.h"
#import <Masonry.h>

@interface ViewController ()<StockChartViewDataSouce>

@property (nonatomic, strong) StockChartView *stockChartView;

@property (nonatomic, strong) KLineGroupModel *groupModel;

@property (nonatomic, strong) NSMutableDictionary <NSString *,KLineGroupModel *> *modelsDict;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    
    
    
}

- (void)reloadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paraDict = @{@"type":@"1min",
                               @"symbol":@"huobibtccny",
                               @"size":@"300"};
    [manager POST:@"https://www.btc123.com/kline/klineapi" parameters:paraDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"isSuc"] boolValue]) {
            KLineGroupModel *groupModel = [KLineGroupModel objectWithArray:responseObject[@"datas"]];
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            [self.stockChartView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {        
        
    }];
}

#pragma mark - StockChartViewDataSouce
- (id)stockDatasWithIndex:(NSInteger)index{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";
        }
            break;
        case 2:
        {
            type = @"1min";
        }
            break;
        case 3:
        {
            type = @"5min";
        }
            break;
        case 4:
        {
            type = @"30min";
        }
            break;
        case 5:
        {
            type = @"1hour";
        }
            break;
        case 6:
        {
            type = @"1day";
        }
            break;
        case 7:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type]){
        [self reloadData];
    }else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}

#pragma mark - setter and getter
- (StockChartView *)stockChartView{
    if (!_stockChartView) {
        _stockChartView = [StockChartView new];
        _stockChartView.itemModels = @[[StockChartViewItemModel itemModelWithTitle:@"指标" type:StockChartcenterViewTypeOther],
                                       [StockChartViewItemModel itemModelWithTitle:@"分时" type:StockChartcenterViewTypeTimeLine],
                                       [StockChartViewItemModel itemModelWithTitle:@"1分" type:StockChartcenterViewTypeKline],
                                       [StockChartViewItemModel itemModelWithTitle:@"5分" type:StockChartcenterViewTypeKline],
                                       [StockChartViewItemModel itemModelWithTitle:@"30分" type:StockChartcenterViewTypeKline],
                                       [StockChartViewItemModel itemModelWithTitle:@"60分" type:StockChartcenterViewTypeKline],
                                       [StockChartViewItemModel itemModelWithTitle:@"日线" type:StockChartcenterViewTypeKline],
                                       [StockChartViewItemModel itemModelWithTitle:@"周线" type:StockChartcenterViewTypeKline]];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _stockChartView;
}

- (NSMutableDictionary<NSString *,KLineGroupModel *> *)modelsDict{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

@end
