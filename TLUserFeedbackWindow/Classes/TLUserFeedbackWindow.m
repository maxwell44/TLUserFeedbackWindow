//
//  UserFeedback.m
//
//  Created by Maxwell on 15/11/16.
//  Copyright © 2015年 Saunter Studio. All rights reserved.
//

#import "TLUserFeedbackWindow.h"
#import "PureLayout.h"
#import "TLHelpViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define APP_THEME_COLOR_BLACKLIGHT      [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1]

#define APP_THEME_COLOR_BLACKDARK       [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1]
#define kButtonWidth 60.0f

@implementation TLUserFeedbackWindow

+ (instancetype)sharedInstance {
    static id  sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}

- (void)addSnapshotImage:(UIImage *)snapshotImage {
    self.imageView.image = snapshotImage;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //为了隐藏状态栏必须设置一个rootViewController
        self.rootViewController = [[TLHelpViewController alloc] init];
        self.rootViewController.view.hidden = YES;
        self.tag = 102;
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.shadeView = [[UIView alloc] init];
        [self.imageView addSubview:self.shadeView];
        [self.shadeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.shadeView.backgroundColor = [UIColor blackColor];
        self.shadeView.alpha = 0.5f;
        self.shadeView.hidden = YES;
        
        //涂鸦板
        self.doodleView = [[TLDoodleView alloc] init];
        [self.imageView addSubview:self.doodleView];
        self.doodleView.penColor = [UIColor redColor];
        self.doodleView.delegate = self;
        [self.doodleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.doodleView.backgroundColor = [UIColor clearColor];
        
    
        
        self.titleView = [[UIView alloc] init];
        self.titleView.backgroundColor = APP_THEME_COLOR_BLACKDARK;
        [self.doodleView addSubview:self.titleView];
        [self.titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.titleView autoSetDimension:ALDimensionHeight toSize:kTitleViewHeight];
        
        self.toolsView = [[UIView alloc] init];
        self.toolsView.backgroundColor = APP_THEME_COLOR_BLACKDARK;
        [self.doodleView  addSubview:self.toolsView];
        [self.toolsView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.toolsView autoSetDimension:ALDimensionHeight toSize:kToolsViewHeight];
        
       // 选画笔
        self.drawBoardView = [[[NSBundle mainBundle] loadNibNamed:@"DrawBoardView" owner:self options:nil] lastObject];
        [self.doodleView addSubview:self.drawBoardView];
        [self.drawBoardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, kToolsViewHeight , 0) excludingEdge:ALEdgeTop];
        self.drawBoardView.alpha = 0;
        self.drawBoardView.hidden = NO;
        self.drawBoardView.deleagate = self;

        
        //输入框
        self.textView = [[UITextView alloc] init];
        [self addSubview:self.textView];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.hidden = YES;
        self.textView.layer.cornerRadius = 5.0f;
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        [self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kTitleViewHeight + 5.0f, 30.0f, 0, 30.0f) excludingEdge:ALEdgeBottom];
        [self.textView autoSetDimension:ALDimensionHeight toSize:180.0f];
        
        
        UILabel *label = [[UILabel alloc] init];
        [self.titleView addSubview:label];
        label.text = @"反馈Bug";
        label.textColor = [UIColor whiteColor];
        [label autoAlignAxis:ALAxisVertical toSameAxisOfView:self.titleView];
        [label autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleView];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [self.titleView addSubview:cancelButton];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius =  5.0f;
        cancelButton.backgroundColor    = APP_THEME_COLOR_BLACKLIGHT;
        cancelButton.titleLabel.font    = [UIFont systemFontOfSize:14.0];
        [cancelButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [cancelButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleView];
        [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0f];
        [cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents: UIControlEventTouchUpInside];
        
        UIButton *finishButton = [[UIButton alloc] init];
        [self.titleView addSubview:finishButton];
        [finishButton setTitle:@"发送" forState:UIControlStateNormal];
        finishButton.backgroundColor = APP_THEME_COLOR_BLACKLIGHT;
        finishButton.layer.cornerRadius =  5.0f;
        finishButton.titleLabel.font    = [UIFont systemFontOfSize:14.0];
        [finishButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [finishButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleView];
        [finishButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20.0f];
        [finishButton addTarget:self action:@selector(finishButtonTouched:) forControlEvents: UIControlEventTouchUpInside];
        
        UIButton *penButton = [[UIButton alloc] init];
        [self.toolsView addSubview:penButton];
        [penButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
        [penButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [penButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.toolsView];
        [penButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:30.0f];
        [penButton addTarget:self action:@selector(penButtonTouched:) forControlEvents: UIControlEventTouchUpInside];

        self.lineView = [[UIView alloc] init];
        [self.toolsView addSubview:self.lineView];
        self.lineView.backgroundColor = [UIColor redColor];
        [self.lineView autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [self.lineView autoSetDimension:ALDimensionHeight toSize:5.0f];
        [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:30.0f];
        [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        
        UIButton *textButton = [[UIButton alloc] init];
        [self.toolsView addSubview:textButton];
        [textButton setImage:[UIImage imageNamed:@"create_white"] forState:UIControlStateNormal];
        [textButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.toolsView];
        [textButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.toolsView];
        [textButton addTarget:self action:@selector(textButtonTouched:) forControlEvents: UIControlEventTouchUpInside];
        
        UIButton *deleteButton = [[UIButton alloc] init];
        [self.toolsView addSubview:deleteButton];
        [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteButton autoSetDimension:ALDimensionWidth toSize:kButtonWidth];
        [deleteButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.toolsView];
        [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:30.0f];
        [deleteButton addTarget:self action:@selector(deleteButtonTouched:) forControlEvents: UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)show {
    if(self.hidden) {
        self.hidden = NO;
        AudioServicesPlaySystemSound (1108);
    }

}

- (void)hide {
    self.hidden = YES;
}

#pragma mark - Button Action

- (void)cancelButtonTouched:(id)sender {
    [self exitWindow];
}

- (void)finishButtonTouched:(id)sender {
    [self.textView resignFirstResponder];
    self.textView.text = nil;
    [self uploadImage];
}

- (void)penButtonTouched:(id)sender {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.drawBoardView.alpha  = 1.0;
        self.drawBoardView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)textButtonTouched:(id)sender {
    //点击了则不可以涂鸦了
    self.shadeView.hidden = NO;
    [self.textView becomeFirstResponder];
    self.doodleView.isDrawing = NO;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toolsView.alpha  = 0.0;
        
    } completion:^(BOOL finished) {
        self.textView.hidden = NO;
    }];
}

- (void)deleteButtonTouched:(id)sender {
    [self.doodleView.lineArray removeLastObject];
    [self.doodleView.lineColor removeLastObject];
    [self.doodleView setNeedsDisplay];
}

#pragma mark - TLDoodleViewDelegate

- (void)hideUserFeedbackWindowRelevanceView {
    
    if (self.doodleView.isDrawing) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //如果选画笔板已经显示了 则titleView和ToolView不做动画.防止一闪一闪的问题.
            if (self.drawBoardView.alpha == 0) {
                self.titleView.alpha  = 0.0;
                self.toolsView.alpha  = 0.0;
            }
            
            self.drawBoardView.alpha  = 0.0;
            self.drawBoardView.hidden = YES;
            self.textView.hidden = YES;
            self.shadeView.hidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.textView.hidden = YES;
        self.shadeView.hidden = YES;
        [self.textView resignFirstResponder];
    }
}

- (void)showUserFeedbackWindowRelevanceView {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.titleView.alpha  = 1.0;
        self.toolsView.alpha  = 1.0;
    } completion:^(BOOL finished) {
        self.doodleView.isDrawing = YES;
        
    }];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        return NO;
    }
    self.contentString =  [textView.text stringByReplacingCharactersInRange:range withString:text];
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.contentString =  textView.text;
    return YES;
}


#pragma mark - DrawBoardViewwDelegate

- (void)changePenColor:(UIColor *)color {
    self.doodleView.penColor  = color;
    self.lineView.backgroundColor = self.doodleView.penColor;
}

- (void)returnColorBorder {
    [self.doodleView viewWithTag:1].layer.borderWidth = 0;
    [self.doodleView viewWithTag:2].layer.borderWidth = 0;
    [self.doodleView viewWithTag:3].layer.borderWidth = 0;
    [self.doodleView viewWithTag:4].layer.borderWidth = 0;
    [self.doodleView viewWithTag:5].layer.borderWidth = 0;
    [self.doodleView viewWithTag:6].layer.borderWidth = 0;
}

#pragma mark - Helper

- (UIImage *)getUserFinishSnapshotImage {
    
    self.titleView.hidden = YES;
    self.toolsView.hidden = YES;
    self.textView.hidden  = YES;
    self.shadeView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 2.0f);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }else {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.titleView.hidden = NO;
    self.toolsView.hidden = NO;
    return finalImage;
}

- (void)exitWindow {
    [self hide];
    [self.textView resignFirstResponder];
    self.shadeView.hidden = YES;
    [self.doodleView.lineArray removeAllObjects];
    [self.doodleView.lineColor removeAllObjects];
    [self.doodleView setNeedsDisplay];
}

- (void)uploadImage {
    //在这上传图片的代码

}

- (void)sendUploadUserFeedback {
    //在这发送给服务器请求的代码
    [self exitWindow];

}

@end
