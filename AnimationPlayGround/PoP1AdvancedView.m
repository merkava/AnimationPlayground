//
//  PoP1AdvancedView.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP1AdvancedView.h"

@implementation PoP1AdvancedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.title = [UILabel new];
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.title.text = @"Tap the circle to transform it. You can chain animations and even use custom properties, like cornerRadius";
        self.title.numberOfLines = 0;
        [self addSubview:self.title];
        
        self.circle = [UIButton buttonWithType:UIButtonTypeCustom];
        self.circle.titleLabel.layer.opacity = 0;
        self.circle.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.];
        [self.circle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.circle setTitle:@"PoP" forState:UIControlStateNormal];
        self.circle.layer.cornerRadius = 50;
        [self addSubview:self.circle];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame)-20, 70);
    if ( self.circle.frame.size.width <= 0  ) {
        self.circle.frame = CGRectMake(CGRectGetWidth(self.frame)/2-100/2, CGRectGetHeight(self.frame)/2-100/2, 100, 100);
    }
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