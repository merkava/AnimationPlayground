//
//  PoP1BasicView.h
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 09/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoP1BasicView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *circle;

@property (nonatomic, strong) UILabel *bouncinessLbl;
@property (nonatomic, strong) UILabel *speedLbl;
@property (nonatomic, strong) UISlider *bounciness;
@property (nonatomic, strong) UISlider *speed;

@end
