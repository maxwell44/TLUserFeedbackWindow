//
//  DoodleView.h
//  onepage
//
//  Created by Maxwell on 15/11/16.
//  Copyright © 2015年 Saunter Studio. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kToolsViewHeight 50.0f
#define kTitleViewHeight 64.0f

@protocol TLDoodleViewDelegate <NSObject>

- (void)showUserFeedbackWindowRelevanceView;
- (void)hideUserFeedbackWindowRelevanceView;

@end

@interface TLDoodleView : UIView

@property (nonatomic, strong) NSMutableArray *lineArray; // 所有线的数组
@property (nonatomic, strong) NSMutableArray *lineColor;
@property (nonatomic, strong) UIColor *penColor;
@property (nonatomic, weak  ) id <TLDoodleViewDelegate>    delegate;
//点击创建TextView的按钮的逻辑判断
@property (nonatomic, assign) BOOL isDrawing;
@end
