//
//  CuteDynamicItem.h
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 22/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuteDynamicItemBehavior : UIDynamicItemBehavior

-(id)initWithItems:(NSArray *)items withElasticity:(CGFloat)elasticity withDensity:(CGFloat)density withFriction:(CGFloat)friction withResistance:(CGFloat)resistance;

@end
