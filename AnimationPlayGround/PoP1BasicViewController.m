//
//  PoPBasic1ViewController.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP1BasicViewController.h"
#import "POP.h"

@interface PoP1BasicViewController ()

@property (nonatomic, assign) CGFloat bouncinees;
@property (nonatomic, assign) CGFloat speed;

@end

@implementation PoP1BasicViewController

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
    self.view = [PoP1BasicView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.view.bounciness addTarget:self action:@selector(changeBounciness:) forControlEvents:UIControlEventValueChanged];
    [self.view.speed addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventValueChanged];
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnim.toValue = [NSValue valueWithCGPoint:point];
    springAnim.springBounciness = self.bouncinees;
    springAnim.springSpeed = self.speed;
    
    [self.view.circle pop_addAnimation:springAnim forKey:@"positionMove"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeBounciness:(UISlider *)sender {
    self.bouncinees = sender.value*20.;
}

-(void)changeSpeed:(UISlider *)sender {
    self.speed = sender.value*20.;
}

@end
