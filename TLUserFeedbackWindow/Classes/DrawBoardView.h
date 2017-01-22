//
//  DrawBoardView.h
//  onepage
//
//  Created by Tian on 15/8/19.
//  Copyright (c) 2015年 Saunter Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawBoardViewwDelegate <NSObject>

- (void)changePenColor:(UIColor *)color;
- (void)returnColorBorder;

@end

@interface DrawBoardView : UIView

@property (weak, nonatomic) id <DrawBoardViewwDelegate> deleagate;

@end
 