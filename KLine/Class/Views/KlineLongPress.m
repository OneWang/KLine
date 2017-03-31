//
//  KlineLongPress.m
//  KLine
//
//  Created by Jack on 2017/3/8.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "KlineLongPress.h"

@implementation KlineLongPress

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawDashLine];
}

/**
 绘制长按的背景线
 */
- (void)drawDashLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    
    CGFloat x = self.stockScrollView.frame.origin.x + self.selectedPositionModel.ClosePoint.x - self.stockScrollView.contentOffset.x;
    
    //绘制横线
    CGContextMoveToPoint(context, self.stockScrollView.frame.origin.x, self.stockScrollView.frame.origin.y + self.selectedPositionModel.ClosePoint.y);
    CGContextAddLineToPoint(context, self.stockScrollView.frame.origin.x + self.stockScrollView.frame.size.width, self.stockScrollView.frame.origin.y + self.selectedPositionModel.ClosePoint.y);
    
    //绘制竖线
    CGContextMoveToPoint(context, x, self.stockScrollView.frame.origin.y);
    CGContextAddLineToPoint(context, x, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - 15 / 2.f);
    CGContextStrokePath(context);
    
    //绘制交叉原点
    CGContextSetStrokeColorWithColor(context, [UIColor decreaseColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextAddArc(context, x, self.stockScrollView.frame.origin.y + self.selectedPositionModel.ClosePoint.y, 3, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //绘制选中的日期
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:9], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSString *dayText = [self timeWithTimeIntervalString:self.selectedModel.date];
    CGRect textRect = [self rectOfNSString:dayText attribute:attribute];
    
    if (x + textRect.size.width/2.0f + 2 > CGRectGetMaxX(self.stockScrollView.frame)) {
        //长按出现方块的背景颜色
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillRect(context, CGRectMake(CGRectGetMaxX(self.stockScrollView.frame) - textRect.size.width, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - 15, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(CGRectGetMaxX(self.stockScrollView.frame) - 4 - textRect.size.width + 2, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - 15 + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    }else{
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillRect(context, CGRectMake(x - textRect.size.width/2.f, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - 15, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(x - textRect.size.width/2.f + 2, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - 15 + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    }
    
    //绘制选中价格
    NSString *priceText = [NSString stringWithFormat:@"%.2f",self.selectedModel.close.floatValue];
    CGRect priceRect = [self rectOfNSString:priceText attribute:attribute];
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, CGRectMake(45 - priceRect.size.width - 9, self.stockScrollView.frame.origin.y + self.selectedPositionModel.ClosePoint.y - priceRect.size.height / 2.f - 2, priceRect.size.width + 4, priceRect.size.height + 4));
    [priceText drawInRect:CGRectMake(45 - priceRect.size.width - 9 + 2, self.stockScrollView.frame.origin.y + self.selectedPositionModel.ClosePoint.y - priceRect.size.height/2.f, priceRect.size.width, priceRect.size.height) withAttributes:attribute];
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [[NSString stringWithFormat:@"%@",string] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
