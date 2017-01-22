//
//  UserProfileSectionHeaderView.m
//  onepage
//
//  Created by Tian on 15/8/19.
//  Copyright (c) 2015年 Saunter Studio. All rights reserved.
//

#import "DrawBoardView.h"

@interface DrawBoardView ()

@property (weak, nonatomic) IBOutlet UIView   *boardBaseView;
@property (weak, nonatomic) IBOutlet UIView   *boardButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *boardGreenButton;
@property (weak, nonatomic) IBOutlet UIButton *boardRedButton;
@property (weak, nonatomic) IBOutlet UIButton *boardBlueButton;
@property (weak, nonatomic) IBOutlet UIButton *boardYellowButton;
@property (weak, nonatomic) IBOutlet UIButton *boardWhiteButton;
@property (weak, nonatomic) IBOutlet UIButton *boardOrangeButton;


@end

@implementation DrawBoardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.boardBaseView.backgroundColor = [UIColor clearColor];
    self.boardButtonsView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    self.boardButtonsView.layer.cornerRadius =  5.0f;
    
    self.boardRedButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardRedButton.clipsToBounds = YES;
    self.boardRedButton.layer.masksToBounds = YES;
    self.boardRedButton.tag = 1;
    
    self.boardGreenButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardGreenButton.clipsToBounds = YES;
    self.boardGreenButton.layer.masksToBounds = YES;
    self.boardGreenButton.tag = 2;
    
    self.boardBlueButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardBlueButton.clipsToBounds = YES;
    self.boardBlueButton.layer.masksToBounds = YES;
    self.boardBlueButton.tag = 3;
    
    self.boardYellowButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardYellowButton.clipsToBounds = YES;
    self.boardYellowButton.layer.masksToBounds = YES;
    self.boardYellowButton.tag = 4;
    
    self.boardWhiteButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardWhiteButton.clipsToBounds = YES;
    self.boardWhiteButton.layer.masksToBounds = YES;
    self.boardWhiteButton.tag = 5;
    
    self.boardOrangeButton.layer.mask = [self maskWithBounds:self.boardRedButton.bounds];
    self.boardOrangeButton.clipsToBounds = YES;
    self.boardOrangeButton.layer.masksToBounds = YES;
    self.boardOrangeButton.tag = 6;
}

- (IBAction)returnColorBorder:(UIButton *)sender {
    if ([self.deleagate respondsToSelector:@selector(returnColorBorder)]) {
        [self.deleagate returnColorBorder];
    }
}

- (IBAction)changeColorButton:(UIButton *)sender {
    if ([self.deleagate respondsToSelector:@selector(changePenColor:)]) {
        [self.deleagate changePenColor:sender.backgroundColor];
    }
}

- (CAShapeLayer *)maskWithBounds:(CGRect)bounds {
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithOvalInRect:bounds].CGPath;
    return mask;
}

@end
