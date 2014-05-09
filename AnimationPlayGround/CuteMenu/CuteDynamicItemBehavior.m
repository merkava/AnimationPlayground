//
//  CuteDynamicItem.m
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 22/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import "CuteDynamicItemBehavior.h"

@implementation CuteDynamicItemBehavior

-(id)initWithItems:(NSArray *)items withElasticity:(CGFloat)elasticity withDensity:(CGFloat)density withFriction:(CGFloat)friction withResistance:(CGFloat)resistance {
    self = [super initWithItems:items];
    
    if ( self ) {
        self.elasticity = elasticity;
        self.density    = density;
        self.friction   = friction;
        self.resistance = resistance;
    }
    
    return self;
}

@end
