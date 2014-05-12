//
//  PoP2BasicView.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP2BasicView.h"

@implementation PoP2BasicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = [UILabel new];
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.title.numberOfLines = 0;
        self.title.text = @"Drag the circle and check what happens when you release it";
        [self addSubview:self.title];
        
        self.circle = [UIView new];
        self.circle.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.];
        self.circle.layer.cornerRadius = 40;
        [self addSubview:self.circle];
        
        self.decelerationLbl = [UILabel new];
        self.decelerationLbl.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.decelerationLbl.textColor = [UIColor grayColor];
        self.decelerationLbl.text = @"Deceleration";
        [self addSubview:self.decelerationLbl];
        
        self.deceleration = [UISlider new];
        [self addSubview:self.deceleration];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame)-100, 70);
    self.circle.frame = CGRectMake(10, 70, 80, 80);
    
    self.decelerationLbl.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 10, 90, 20);
    self.deceleration.frame = CGRectMake(CGRectGetWidth(self.frame)-80-10, 35, 80, 30);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



@end
