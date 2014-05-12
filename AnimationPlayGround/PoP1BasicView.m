//
//  PoP1BasicView.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP1BasicView.h"

@implementation PoP1BasicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.title = [UILabel new];
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.title.text = @"Tap anywhere. Try tapping fast with 2 fingers to catch the ball in the middle";
        self.title.numberOfLines = 0;
        [self addSubview:self.title];
        
        self.circle = [UIView new];
        self.circle.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.];
        self.circle.layer.cornerRadius = 40;
        [self addSubview:self.circle];
        
        self.bouncinessLbl = [UILabel new];
        self.bouncinessLbl.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.bouncinessLbl.textColor = [UIColor grayColor];
        self.bouncinessLbl.text = @"Bounciness";
        [self addSubview:self.bouncinessLbl];
        
        self.bounciness = [UISlider new];
        [self addSubview:self.bounciness];
        
        self.speedLbl = [UILabel new];
        self.speedLbl.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.speedLbl.text = @"Speed";
        self.speedLbl.textColor = [UIColor grayColor];
        [self addSubview:self.speedLbl];
        
        self.speed = [UISlider new];
        [self addSubview:self.speed];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame)-100, 60);
    self.circle.frame = CGRectMake(10, 70, 80, 80);
    
    self.bouncinessLbl.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 10, 80, 20);
    self.bounciness.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 35, 80, 30);
    self.speedLbl.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 70, 80, 20);
    self.speed.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 95, 80, 30);
}

@end
