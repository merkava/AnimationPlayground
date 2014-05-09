//
//  CuteMenu.m
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 19/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import "CuteMenu.h"
#import "CuteMenuButton.h"
#import "CuteDynamicItemBehavior.h"

@interface CuteMenu ()

@property (nonatomic, strong) NSArray *buttonStruct;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) UIViewController *container;
@property (nonatomic, strong) UIAttachmentBehavior *attach;
@property (nonatomic, strong) UIGravityBehavior *gravity;

@property (nonatomic, strong) NSMutableArray *menuButtons;
@property (nonatomic, strong) NSMutableArray *subMenuButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicAnimator *subAnimator;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, assign) BOOL subMenuOpen;
@property (nonatomic, assign) BOOL menuOpen;
@property (nonatomic, assign) BOOL hiding;

@end

@implementation CuteMenu

-(NSMutableArray *)menuButtons {
    if ( !_menuButtons ) {
        _menuButtons = [NSMutableArray new];
    }
    
    return _menuButtons;
}

-(NSMutableArray *)subMenuButtons {
    if ( !_subMenuButtons ) {
        _subMenuButtons = [NSMutableArray new];
    }
    
    return _subMenuButtons;
}


-(id)initWithMenuStructure:(NSArray *)buttonStruct andContainerVC:(UIViewController *)container {
    self.buttonStruct = buttonStruct;
    self.container = container;
    
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.homeButton setTitle:@"Home" forState:UIControlStateNormal];
        self.homeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.];
        [self.homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.homeButton.layer.cornerRadius = kMenuHomeRadius;
        self.homeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.homeButton.layer.borderWidth = 2.;
        [self.homeButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.homeButton];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.container.view];
        self.subAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.container.view];

        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHome:)];
        [self.homeButton addGestureRecognizer:self.longPress];
        
    }
    return self;
}

-(void)show {
    if ( !self.hiding ) {
        self.menuOpen = YES;
        self.frame = self.container.view.bounds;
        [self.container.view addSubview:self];

        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        }];

        //Buttons!
        self.menuButtons = nil;
        NSInteger index = 0;
        for ( NSDictionary *buttonDic in self.buttonStruct ) {
            CuteMenuButton *button = [CuteMenuButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonDic[@"title"] forState:UIControlStateNormal];
            button.frame = CGRectMake(CGRectGetWidth(self.container.view.frame)/2, -100, kMenuItemsRadius*2, kMenuItemsRadius*2);
            button.tag = index;
            [button addTarget:self action:@selector(pressedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            [self.menuButtons addObject:button];
            
            index++;
        }

        self.homeButton.frame = CGRectZero;
    }
    
}

-(void)hide {
    self.hiding = YES;
    
    self.menuOpen = NO;
    self.subMenuOpen = NO;
    self.menuIndex = 0;
    [self.homeButton setTitle:@"Home" forState:UIControlStateNormal];
    
    [self.animator removeAllBehaviors];
    [self.subAnimator removeAllBehaviors];
    
    NSMutableArray *items = [self.menuButtons mutableCopy];
    [items addObjectsFromArray:self.subMenuButtons];
    [items addObject:self.homeButton];
    
    [self addGravityWithVector:CGVectorMake(0, 5) andItems:items onAnimator:self.animator];
    
    [UIView animateWithDuration:1.35 animations:^{
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.hiding = NO;
    }];

}

-(BOOL)isShown {
    return self.menuOpen;
}

-(void)layoutSubviews {
    if ( self.homeButton.frame.size.width <= 0 ) {
        self.homeButton.frame = CGRectMake(CGRectGetWidth(self.container.view.frame)/2-kMenuHomeRadius, CGRectGetHeight(self.container.view.frame)/2-kMenuHomeRadius-100, kMenuHomeRadius*2, kMenuHomeRadius*2);
        
        [self animateMenu];
    }
}

static const CGFloat  kDamping      = 1.;
static const CGFloat  kFrequency    = 4.;

-(void)animateMenu {
    [self.animator removeAllBehaviors];
    [self addDynamicItemBehavior];
    
    [UIView animateWithDuration:0.35
                          delay:0.1
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.homeButton.center = [self checkClosestSide];
        
    } completion:nil];
    
    NSInteger index = 0;
    CGFloat posX = self.homeButton.center.x;
    NSInteger direction = (self.homeButton.frame.origin.y > 300.) ? -1 : 1;
    CGFloat posY = direction > 0 ? self.homeButton.frame.origin.y+kMenuItemsGap+kMenuHomeRadius : self.homeButton.frame.origin.y-kMenuHomeRadius-kMenuMargin;

    for ( UIButton *button in self.menuButtons ) {
        //Animation
        CGFloat damping = 0.17*(self.menuButtons.count-index);
        [self addSnapWithDamping:damping andItem:button andSnapPoint:CGPointMake(posX, posY) onAnimator:self.animator];
        
        posY += direction*kMenuItemsGap;
        index++;
    }

    
}

#pragma mark - Home Button Tracker

-(void)longPressHome:(UILongPressGestureRecognizer *)sender {
    if ( !self.subMenuOpen ) {
        if ( sender.state == UIGestureRecognizerStateBegan ) {
            self.homeButton.enabled = NO;
            
            [self.animator removeAllBehaviors];
            [self addDynamicItemBehavior];
            
            self.gravity = [self addGravityWithVector:CGVectorMake(0, 1) andItems:self.menuButtons onAnimator:self.animator];
            NSInteger index = 0;
            for ( UIButton *button in self.menuButtons ) {
                //Animation
                UIButton *attachButton;
                if ( button.tag == 0 ) {
                    self.attach = [self addAttachMentWithDamping:kDamping andFrequency:kFrequency andLenght:kMenuItemsGap withItem:button andAttachItem:nil withAnchor:self.homeButton.center onAnimator:self.animator];
                    
                } else {
                    attachButton = self.menuButtons[index-1];
                    [self addAttachMentWithDamping:kDamping andFrequency:kFrequency andLenght:kMenuItemsGap withItem:button andAttachItem:attachButton withAnchor:CGPointZero onAnimator:self.animator];
                }
                
                index++;
            }
            
        } else if ( sender.state == UIGestureRecognizerStateChanged ) {
            CGPoint center = self.homeButton.center;
            center = [sender locationInView:self.container.view];
            self.homeButton.center = center;
            
            self.attach.anchorPoint = self.homeButton.center;
            
            if ( self.homeButton.center.y < CGRectGetHeight(self.container.view.frame)/2 ) {
                //Going up, gravity down
                self.gravity.gravityDirection = CGVectorMake(0, 1);
            } else {
                //Going down, gravity up
                self.gravity.gravityDirection = CGVectorMake(0, -1);
            }
            
            
        } else if ( sender.state == UIGestureRecognizerStateEnded ||  sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled ) {
            self.homeButton.enabled = YES;
            [self animateMenu];
        }
    }
}

#pragma mark - Buttons

-(void)homeButtonPressed:(UIButton *)sender {
    if ( self.subMenuOpen ) {
        [self.homeButton setTitle:@"Home" forState:UIControlStateNormal];
        self.subMenuOpen = NO;
        [self closeSubMenu];
        [self animateMenu];
    }
}

-(void)pressedMenuButton:(UIButton *)sender {
    NSDictionary *buttonData = self.buttonStruct[sender.tag];
    if ( !buttonData[@"submenu"] ) {
        [self menuAction:sender.tag];
        return;
    }
    
    self.subMenuOpen = YES;
    
    [self.animator removeAllBehaviors];
    [self addDynamicItemBehavior];
    
    NSArray *fromPoints = @[NSStringFromCGPoint(CGPointMake(0, CGRectGetHeight(self.container.view.frame))),
                            NSStringFromCGPoint(CGPointZero),
                            NSStringFromCGPoint(CGPointMake(CGRectGetWidth(self.container.view.frame), 0)),
                            NSStringFromCGPoint(CGPointZero)
                            ];
    NSArray *toPoints  = @[NSStringFromCGPoint(CGPointMake(CGRectGetWidth(self.container.view.frame), CGRectGetHeight(self.container.view.frame))),
                            NSStringFromCGPoint(CGPointMake(0, CGRectGetHeight(self.container.view.frame))),
                            NSStringFromCGPoint(CGPointMake(CGRectGetWidth(self.container.view.frame), CGRectGetHeight(self.container.view.frame))),
                            NSStringFromCGPoint(CGPointMake(CGRectGetWidth(self.container.view.frame), 0))
                            ];
    [self addCollisionWithItems:self.menuButtons withBoundaryFromPoints:fromPoints toPoints:toPoints onAnimator:self.animator];
    
    CGFloat distance = self.homeButton.center.x < 200. ? kMenuItemsGap : -kMenuItemsGap;
    [self addSnapWithDamping:0.6 andItem:sender andSnapPoint:CGPointMake(self.homeButton.center.x+distance, self.homeButton.center.y) onAnimator:self.animator];
    
    NSMutableArray *buttons = [self.menuButtons mutableCopy];
    [buttons removeObject:sender];
    
    for ( UIButton *button in buttons ) {
        CGFloat magnitude = 2.3;
        CGFloat angle =  (-0.7 * M_PI) + (arc4random()%25 / 10);
        [self addPushWithMagnitude:magnitude andItems:@[button] andAngle:angle andMode:UIPushBehaviorModeInstantaneous onAnimator:self.animator];
    }
    
    NSInteger direction = (self.homeButton.frame.origin.y > 300.) ? -1 : 1;
    [self addGravityWithVector:CGVectorMake(0, 1*direction) andItems:buttons onAnimator:self.animator];
    
    //Draw submenu!
    [self drawSubMenu:buttonData[@"submenu"]];
    self.menuIndex = sender.tag;
    
}

#pragma mark - Submenu

-(void)drawSubMenu:(NSArray *)submenu {
    //Buttons!
    [self.homeButton setTitle:@"Back" forState:UIControlStateNormal];
    [self cleanSubMenu];
    
    NSInteger index = 0;
    for ( NSDictionary *buttonDic in submenu ) {
        CuteMenuButton *button = [CuteMenuButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonDic[@"title"] forState:UIControlStateNormal];
        button.frame = CGRectMake(CGRectGetWidth(self.container.view.frame)/2, -100, kMenuItemsRadius*2, kMenuItemsRadius*2);
        button.tag = index;
        [button addTarget:self action:@selector(pressedSubMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self.subMenuButtons addObject:button];
        
        index++;
    }
    
    index = 0;
    CGFloat distance = self.homeButton.center.x < 200. ? kMenuItemsGap : -kMenuItemsGap;
    CGFloat posX = self.homeButton.center.x+distance;
    NSInteger direction = (self.homeButton.frame.origin.y > 300.) ? -1 : 1;
    CGFloat posY = direction > 0 ? self.homeButton.frame.origin.y+kMenuItemsGap+kMenuHomeRadius : self.homeButton.frame.origin.y-kMenuHomeRadius-kMenuMargin;
    
    for ( UIButton *button in self.subMenuButtons ) {
        //Animation
        CGFloat damping = 0.17*(self.menuButtons.count-index);
        damping = ( damping < 0.3 ) ? 0.3 : damping;
        [self addSnapWithDamping:damping andItem:button andSnapPoint:CGPointMake(posX, posY) onAnimator:self.subAnimator];
        
        posY += direction*kMenuItemsGap;
        index++;
    }
}

-(void)closeSubMenu {
    [self.subAnimator removeAllBehaviors];
    [self addDynamicItemBehavior];
    
    for ( UIButton *button in self.subMenuButtons ) {
        CGFloat magnitude = 0.8;
        CGFloat angle =  (-0.7 * M_PI) + (arc4random()%25 / 10);
        [self addPushWithMagnitude:magnitude andItems:@[button] andAngle:angle andMode:UIPushBehaviorModeInstantaneous onAnimator:self.subAnimator];
    }
    
    [self addGravityWithVector:CGVectorMake(0, 1) andItems:self.subMenuButtons onAnimator:self.subAnimator];
    
    //Collision to stop movement and remove buttons.
    
}

-(void)cleanSubMenu {
    for ( UIButton *button in self.subMenuButtons ) {
        [button removeFromSuperview];
    }
    
    self.subMenuButtons = nil;
    
}

-(void)pressedSubMenuButton:(UIButton *)sender {
    [self subMenuAction:sender.tag withMenuIndex:self.menuIndex];
}

#pragma mark - Utilities

-(void)addDynamicItemBehavior {
    CuteDynamicItemBehavior *cuteItem = [[CuteDynamicItemBehavior alloc] initWithItems:self.menuButtons withElasticity:0.5 withDensity:1 withFriction:1 withResistance:1];
    [self.animator addBehavior:cuteItem];
}

-(UICollisionBehavior *)addCollisionWithItems:(NSArray *)items withBoundaryFromPoints:(NSArray *)fromPoints toPoints:(NSArray *)toPoints onAnimator:(UIDynamicAnimator *)animator {
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.menuButtons];
    NSInteger index = 0;
    for ( NSString *fromPoint in fromPoints ) {
        [collision addBoundaryWithIdentifier:[NSString stringWithFormat:@"%d_collision",index] fromPoint:CGPointFromString(fromPoint) toPoint:CGPointFromString(toPoints[index])];
        index++;
    }
    
    [animator addBehavior:collision];
    
    return collision;
}

-(UIAttachmentBehavior *)addAttachMentWithDamping:(CGFloat)damping andFrequency:(CGFloat)frequency andLenght:(CGFloat)lenght withItem:(UIView *)item andAttachItem:(UIView *)attachItem withAnchor:(CGPoint)anchor onAnimator:(UIDynamicAnimator *)animator {
    UIAttachmentBehavior *attach;
    if ( item && attachItem ) {
        attach = [[UIAttachmentBehavior alloc] initWithItem:item attachedToItem:attachItem];
    } else {
        attach = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:anchor];
    }
    
    attach.damping = damping;
    attach.frequency = frequency;
    attach.length  = lenght;
    [animator addBehavior:attach];
    
    return attach;
}

-(UIGravityBehavior *)addGravityWithVector:(CGVector)vector andItems:(NSArray *)items onAnimator:(UIDynamicAnimator *)animator {
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:items];
    gravity.gravityDirection = vector;
    [animator addBehavior:gravity];
    
    return gravity;
}

-(UISnapBehavior *)addSnapWithDamping:(CGFloat)damping andItem:(UIView *)item andSnapPoint:(CGPoint)snapPoint onAnimator:(UIDynamicAnimator *)animator {
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:item snapToPoint:snapPoint];
    snap.damping = damping;
    [animator addBehavior:snap];
    
    return snap;
}

-(UIPushBehavior *)addPushWithMagnitude:(CGFloat)magnitude andItems:(NSArray *)items andAngle:(CGFloat)angle andMode:(UIPushBehaviorMode)mode onAnimator:(UIDynamicAnimator *)animator {
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:items mode:mode];
    push.magnitude = magnitude;
    push.angle = angle;
    [animator addBehavior:push];
    
    return push;
}

-(CGPoint)checkClosestSide {
    CGRect frame = self.homeButton.frame;
    CGFloat posX, posY;
    if ( frame.origin.x < CGRectGetWidth(self.frame)/2 ) {
        posX = kMenuInitialOffset;
    } else {
        posX = CGRectGetWidth(self.frame)-kMenuInitialOffset;
    }
    
    if ( frame.origin.y < CGRectGetHeight(self.frame)/2 ) {
        posY = kMenuInitialOffset;
        
    } else {
        posY = CGRectGetHeight(self.frame)-kMenuInitialOffset;
        
    }
    
    return CGPointMake(posX, posY);
    
}

#pragma mark - Menu Actions

-(void)menuAction:(NSInteger)index {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(pressedMenuOptionWithIndex:)] ) {
        [self.delegate pressedMenuOptionWithIndex:index];
    }
}

-(void)subMenuAction:(NSInteger)index withMenuIndex:(NSInteger)menuIndex {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(pressedSubMenuOptionWithIndex:andSubMenuIndex:)] ) {
        [self.delegate pressedSubMenuOptionWithIndex:menuIndex andSubMenuIndex:index];
    }
}

@end
