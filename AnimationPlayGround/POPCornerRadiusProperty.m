//
//  POPCornerRadiusProperty.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 12/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "POPCornerRadiusProperty.h"

@implementation POPCornerRadiusProperty

+(POPAnimatableProperty *)propertyWithName:(NSString *)name {
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.mobgen.layer.cornerRadius" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj cornerRadius];
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setCornerRadius:values[0]];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    
    return prop;
}

@end
