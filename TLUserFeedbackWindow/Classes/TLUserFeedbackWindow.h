//
//  UserFeedback.h
//  onepage
//
//  Created by Maxwell on 15/11/16.
//  Copyright © 2015年 Saunter Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawBoardView.h"
#import "TLDoodleView.h"
#import "DrawBoardView.h"

@interface TLUserFeedbackWindow : UIWindow <TLDoodleViewDelegate,UITextViewDelegate,DrawBoardViewwDelegate>

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) TLDoodleView  *doodleView;
@property (strong, nonatomic) DrawBoardView *drawBoardView;
@property (strong, nonatomic) UIView        *titleView;
@property (strong, nonatomic) UIView        *toolsView;
@property (strong, nonatomic) UITextView    *textView;
@property (copy  , nonatomic) NSString      *contentString;
@property (strong, nonatomic) UIView        *lineView;
@property (strong ,nonatomic) UIView        *shadeView;
@property (strong, nonatomic) UIImage       *coverImage;

+ (TLUserFeedbackWindow *)sharedInstance;

- (void)addSnapshotImage:(UIImage *)snapshotImage;
- (void)show;
- (void)hide;

@end
