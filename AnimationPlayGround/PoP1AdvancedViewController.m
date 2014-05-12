//
//  PoP1AdvancedViewController.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP1AdvancedViewController.h"
#import "POP.h"
#import "POPCornerRadiusProperty.h"

@interface PoP1AdvancedViewController ()

@property (nonatomic, assign) BOOL reverse;

@end

@implementation PoP1AdvancedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

-(void)loadView {
    self.view = [PoP1AdvancedView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view.circle addGestureRecognizer:tap];
    
}

-(void)handleTap:(id)sender {
    [self addPopAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Pop Animations

-(void)addPopAnimations {
    self.view.circle.userInteractionEnabled = NO;
    //pop stuff, just because I like it! :)
    //https://github.com/facebook/pop
    POPBasicAnimation *cornerRadius = [POPBasicAnimation easeOutAnimation];
    cornerRadius.delegate = self;
    cornerRadius.property = [POPCornerRadiusProperty propertyWithName:@"cornerRadius"];
    if ( self.view.circle.layer.cornerRadius > 0 ) {
        self.reverse = YES;
    } else {
        self.reverse = NO;
    }
    cornerRadius.toValue = ( self.reverse ) ? @0 : @50;
    cornerRadius.name = @"cornerRadius";
    [self.view.circle.layer pop_addAnimation:cornerRadius forKey:@"cornerRadius"];
    
}

#pragma mark - Pop Animation Delegate

-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ( finished ) {
        if ( [anim.name isEqualToString:@"cornerRadius"] ) {
            POPSpringAnimation *color = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
            color.delegate = self;
            color.toValue = (id)[UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.].CGColor;
            color.springBounciness = 20;
            color.springSpeed = 1;
            [self.view.circle.layer pop_addAnimation:color forKey:@"color"];
            
        } else {
            POPSpringAnimation *size = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            size.toValue = ( self.reverse ) ? [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-20, 30)] : [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
            size.springBounciness = 20;
            size.springSpeed = 10;
            [self.view.circle.layer pop_addAnimation:size forKey:@"size"];
            
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            anim.fromValue = ( self.reverse ) ? @(0.0) : @(1.0);
            anim.toValue = ( self.reverse ) ? @(1.0) : @(0.0);
            [self.view.circle.titleLabel.layer pop_addAnimation:anim forKey:@"fade"];
            self.view.circle.userInteractionEnabled = YES;
        }
        
    }
}

@end
