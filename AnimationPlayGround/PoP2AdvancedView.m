//
//  PoP2AdvancedView.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP2AdvancedView.h"

@implementation PoP2AdvancedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = [UILabel new];
        self.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.title.text = @"Tap anywhere to see the text below animate a random property";
        self.title.numberOfLines = 0;
        [self addSubview:self.title];
        
        self.animProperty = [UILabel new];
        self.animProperty.font = [UIFont systemFontOfSize:12.];
        [self addSubview:self.animProperty];
        
        self.animTitle = [UILabel new];
        self.animTitle.backgroundColor = [UIColor whiteColor];
        self.animTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.animTitle.textAlignment = NSTextAlignmentCenter;
        NSString *text = @"mobgenº iOS developers";
        CGFloat fontSize = ( IS_IPAD ) ? 30 : 18.;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = NSMakeRange(0, 6);
        [title beginEditing];
        
        [title addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:fontSize+4]
                      range:range];
        [title addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor]
                      range:range];
        [title addAttribute:NSStrokeColorAttributeName
                      value:[UIColor greenColor]
                      range:range];
        
        range = NSMakeRange(6, 5);
        [title addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:fontSize]
                      range:range];
        [title addAttribute:NSForegroundColorAttributeName
                      value:[UIColor orangeColor]
                      range:range];
        
        range = NSMakeRange(11, text.length-11);
        [title addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:fontSize]
                      range:range];
        [title addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blueColor]
                      range:range];
        [title endEditing];
        
        self.animTitle.attributedText = title;
        
        self.animTitle.numberOfLines = 0;
        [self addSubview:self.animTitle];

        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame)-70, 50);
    self.animProperty.frame = CGRectMake(CGRectGetWidth(self.frame)-70, 10, 70, 50);
    self.animTitle.frame = CGRectMake(10, 100, CGRectGetWidth(self.frame)-20, 200);
}

@end
