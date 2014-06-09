//
//  AutoLayoutExampleView.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 14/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "AutoLayoutExampleView.h"

@implementation AutoLayoutExampleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.square = [UIView new];
        self.square.backgroundColor = [UIColor redColor];
        self.square.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.square];
        
    }
    return self;
}

-(void)updateConstraints {
    NSDictionary *metrics = @{@"squareSize" : @200 };
    
    NSDictionary *viewsDictionary = @{@"square":self.square};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[square(squareSize)]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:viewsDictionary];
    //[self.square addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[square(squareSize)]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:viewsDictionary];
    [self.square addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[square]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[square]-50-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [self addConstraints:constraints];
    
    [super updateConstraints];
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
