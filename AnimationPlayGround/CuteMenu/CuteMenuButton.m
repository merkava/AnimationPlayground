//
//  CuteMenuButton.m
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 19/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import "CuteMenuButton.h"
#import "CuteMenu.h"

@implementation CuteMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitle:@"Home" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12.];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.cornerRadius = kMenuItemsRadius;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.;
        
    }
    return self;
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
