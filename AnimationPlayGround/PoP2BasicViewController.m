//
//  PoP2BasicViewController.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP2BasicViewController.h"
#import "POP.h"

@interface PoP2BasicViewController () <POPAnimationDelegate>

@property (nonatomic, assign) CGFloat decelerationValue;

@end

@implementation PoP2BasicViewController

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
    self.view = [PoP2BasicView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view.circle addGestureRecognizer:pan];
    
    [self.view.deceleration addTarget:self action:@selector(changeDeceleration:) forControlEvents:UIControlEventValueChanged];
    self.decelerationValue = 0.987;
    self.view.deceleration.value = 0.4;
}

-(void)handlePan:(UIPanGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateChanged ) {
        [self.view.circle pop_removeAnimationForKey:@"decay"];
        [self.view.circle pop_removeAnimationForKey:@"reset"];
        //CGPoint center = self.view.circle.center;
        //center.x = [sender locationInView:self.view].x;
        self.view.circle.center = [sender locationInView:self.view];
    } else if ( sender.state == UIGestureRecognizerStateEnded ) {
        POPDecayAnimation *decayAnim = [POPDecayAnimation animationWithPropertyNamed:kPOPViewCenter];
        decayAnim.delegate = self;
        decayAnim.velocity = [NSValue valueWithCGPoint:[sender velocityInView:self.view]];
        decayAnim.deceleration = self.decelerationValue;
        [self.view.circle pop_addAnimation:decayAnim forKey:@"decay"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ( finished ) {
        //If the circle is out of sight, reposition it! :D
        if ( self.view.circle.center.x < 0 || self.view.circle.center.x > CGRectGetWidth(self.view.frame) || self.view.circle.center.y < 0 || self.view.circle.center.y > CGRectGetHeight(self.view.frame) ) {
            POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            springAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(10+40, 40+40)];
            springAnim.springBounciness = arc4random_uniform(20);
            springAnim.springSpeed = arc4random_uniform(20);
            [self.view.circle pop_addAnimation:springAnim forKey:@"reset"];
        }
    }
}

-(void)changeDeceleration:(UISlider *)sender {
    self.decelerationValue = (1-(sender.value*0.04)>=1)?0.999:1-(sender.value*0.04);
}

@end
