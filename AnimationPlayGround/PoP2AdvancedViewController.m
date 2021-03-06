//
//  PoP2AdvancedViewController.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "PoP2AdvancedViewController.h"
#import "POP.h"
#import "POPCGUtils.h"

@interface PoP2AdvancedViewController () <POPAnimationDelegate>

@property (nonatomic, strong) POPAnimatableProperty *animatableProperty;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation PoP2AdvancedViewController

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
    self.view = [PoP2AdvancedView new];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tap];
    
    self.animatableProperty = [POPAnimatableProperty propertyWithName:@"com.mobgen.random.text.property" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            NSAttributedString *attrStr = [obj attributedText];
            NSRange range = NSMakeRange(0, 0);
            NSDictionary *props = [attrStr attributesAtIndex:0 effectiveRange:&range];
            CGFloat value = 0;
            if ( [self.property isEqualToString:NSKernAttributeName] || [self.property isEqualToString:NSStrokeWidthAttributeName] || [self.property isEqualToString:NSBaselineOffsetAttributeName] || [self.property isEqualToString:NSObliquenessAttributeName] ) {
                value = [[props valueForKey:self.property] floatValue];
                values[0] = value;
                
            } else if ( [self.property isEqualToString:@"OppositeStroke"] ) {
                value = [[props valueForKey:NSStrokeWidthAttributeName] floatValue];
                values[0] = value;
                
            } else if ( [self.property isEqualToString:NSFontAttributeName] ) {
                value = ((UIFont *)[props valueForKey:self.property]).pointSize;
                values[0] = value;
                
            } else if ( [self.property isEqualToString:NSForegroundColorAttributeName] ) {
                struct CGColor *color = ((UIColor *)[props valueForKey:self.property]).CGColor;
                POPCGColorGetRGBAComponents(color, values);
            }
            
            
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            NSMutableAttributedString *attrStr = [[obj attributedText] mutableCopy];
            NSRange range = NSMakeRange(0, 0);
            while ( range.location+range.length != [[attrStr string] length] ) {
                NSMutableDictionary *props = [[attrStr attributesAtIndex:range.location+range.length effectiveRange:&range] mutableCopy];
                if ( [self.property isEqualToString:NSKernAttributeName] || [self.property isEqualToString:NSStrokeWidthAttributeName] || [self.property isEqualToString:NSBaselineOffsetAttributeName] || [self.property isEqualToString:NSObliquenessAttributeName] ) {
                    [props setObject:@(values[0]) forKey:self.property];
                    
                } else if ( [self.property isEqualToString:@"OppositeStroke"] ) {
                    [props setObject:@(-1*values[0]) forKey:NSStrokeWidthAttributeName];
                    
                } else if ( [self.property isEqualToString:NSForegroundColorAttributeName] ) {
                    [props setObject:((UIColor *)POPUIColorRGBACreate(values)) forKey:NSForegroundColorAttributeName];
                    
                } else {
                    UIFont *font = [UIFont fontWithName:((UIFont *)[props valueForKey:self.property]).fontName size:values[0]] ;
                    [props setObject:font forKey:self.property];
                    
                }
                
                [attrStr setAttributes:props range:range];
                
            }
            [obj setAttributedText:attrStr];
            
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
    self.tap.enabled = NO;
    
    //NSArray *props = @[NSKernAttributeName, NSFontAttributeName, NSStrokeWidthAttributeName, NSObliquenessAttributeName, @"OppositeStroke", NSForegroundColorAttributeName];
    NSArray *props = @[NSKernAttributeName, NSFontAttributeName,NSForegroundColorAttributeName];
    
    
    self.property = props[arc4random_uniform(props.count)];
    self.view.animProperty.text = self.property;
    
    POPSpringAnimation *spring = [POPSpringAnimation animation];
    
    spring.property = self.animatableProperty;
    spring.delegate = self;
    NSNumber *goToValue = ( IS_IPAD ) ? @(50.) : @(30.);
    if ( [self.property isEqualToString:NSStrokeWidthAttributeName] || [self.property isEqualToString:@"OppositeStroke"] ) {
        goToValue = @([goToValue floatValue]/5.);
    } else if ( [self.property isEqualToString:NSForegroundColorAttributeName] ) {
        goToValue = (id)[UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.].CGColor;
    }
    spring.toValue = goToValue;
    spring.springBounciness = 20;
    spring.springSpeed = 10;
    [self.view.animTitle pop_addAnimation:spring forKey:@"random.text.property"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pop Stuff Delegate

-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ( finished ) {
        if ( ![anim.name isEqualToString:@"endAnimation"] ) {
            POPSpringAnimation *spring = [POPSpringAnimation animation];
            spring.name = @"endAnimation";
            spring.property = self.animatableProperty;
            spring.delegate = self;
            if ( [self.property isEqualToString:NSForegroundColorAttributeName] ) {
                spring.toValue = (id)[UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.].CGColor;
                
            } else {
                if ( [self.property isEqualToString:NSFontAttributeName] ) {
                    spring.toValue = @(22);
                } else {
                    spring.toValue = @(0);
                }
                
            }
            spring.springBounciness = 20;
            spring.springSpeed = 15;
            [self.view.animTitle pop_addAnimation:spring forKey:@"random.text.property"];
        } else {
            self.tap.enabled = YES;
        }
    }
}

@end
