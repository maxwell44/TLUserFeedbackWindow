//
//  DoodleView.m
//  onepage
//
//  Created by Maxwell on 15/11/16.
//  Copyright © 2015年 Saunter Studio. All rights reserved.
//

#import "TLDoodleView.h"

#define ScreenHeight      [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth       [[UIScreen mainScreen] bounds].size.width

@interface TLDoodleView ()

@property (assign, nonatomic) BOOL isDrawArea;

@end

@implementation TLDoodleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lineArray = [NSMutableArray array];
        self.penColor  = [UIColor greenColor];
        self.lineColor = [NSMutableArray array];
        self.isDrawing = YES;
        self.isDrawArea = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//重写drawRect:方法  用于重新绘制View
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.isDrawing) {
        if(self.isDrawArea){
            //    当前view的绘制信息
            CGContextRef context = UIGraphicsGetCurrentContext();
            //    设置线条宽度
            CGContextSetLineWidth(context, 3);
            //    设置线条颜色
            CGContextSetStrokeColorWithColor(context, [self penColor].CGColor);
            //    设置线的起点
            //    CGContextMoveToPoint(context, 0, 0);
            //    添加一条线，规定线的终点
            //    CGContextAddLineToPoint(context, 200, 200);
            
            for (int i = 0; i < self.lineArray.count; i++) {
                //       获取到每一条线（点的数组）
                NSMutableArray *points = [self.lineArray objectAtIndex:i];
                UIColor *color = [self.lineColor objectAtIndex:i];
                //        如果数组中没有点 跳过此次循环
                if (0 == points.count) {
                    continue;
                }
                for (int j = 0; j < points.count - 1; j ++) {
                    //      获取每一个点及这个点之后的点， 连线
                    CGContextSetStrokeColorWithColor(context, color.CGColor);
                    NSValue *pointValueA = [points objectAtIndex:j];
                    NSValue *pointValueB = [points objectAtIndex:j + 1];
                    CGPoint pointA = [pointValueA CGPointValue];
                    CGPoint pointB = [pointValueB CGPointValue];
                    CGContextMoveToPoint(context, pointA.x, pointA.y);
                    CGContextAddLineToPoint(context, pointB.x, pointB.y);
                }
                //        根据绘制信息在uiview上绘制图形
                CGContextStrokePath(context);
            }
        }
    }
    
}
//记录划线的点信息
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches]  anyObject];
    [touch gestureRecognizers];
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self];
    // See if the point touched is within these rectangular bounds
    
    //如果在TitleView和ToolsView的区域则不涂鸦 也不隐藏这两个View
    if (CGRectContainsPoint(CGRectMake(0, 0, ScreenWidth, kTitleViewHeight), point)) {
        self.isDrawArea = NO;
    } else if (CGRectContainsPoint(CGRectMake(0, ScreenHeight - kToolsViewHeight, ScreenWidth, kToolsViewHeight), point)){
        self.isDrawArea = NO;
    } else {
        if ([self.delegate respondsToSelector:@selector(hideUserFeedbackWindowRelevanceView)]) {
            [self.delegate hideUserFeedbackWindowRelevanceView];
        }
        self.isDrawArea = YES;
    }
    
    //每次接触大屏幕，都需要创建一条线（点的数组）
    NSMutableArray *points = [NSMutableArray array];
    //    每次都将新的线添加到线的数组中，方便管理
    [self.lineArray addObject:points];
    [self.lineColor addObject:self.penColor];
    //    将每次的颜色添加到数组
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];//集合的取值
    CGPoint point = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];//因为数组内只能存对象类型
    //强制view调用drawRect：方法 实现边画边绘制
    if (self.isDrawArea) {
        //获取到当前的（点的数组）
        NSMutableArray *points = [self.lineArray lastObject];
        //把点添加到线（点的数组）中
        [points addObject:pointValue];
        [self setNeedsDisplay];
    }
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(showUserFeedbackWindowRelevanceView)]) {
        [self.delegate showUserFeedbackWindowRelevanceView];
    }
}

@end
