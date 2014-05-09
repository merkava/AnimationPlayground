//
//  CuteMenu.h
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 19/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

#define kMenuInitialOffset  ((IS_IPAD) ? 90. : 50.)
#define kMenuMargin         ((IS_IPAD) ? 20. : 10.)
#define kMenuItemsGap       ((IS_IPAD) ? 55*2+20 : 30*2+10)
#define kMenuHomeRadius     ((IS_IPAD) ? 55 : 30)
#define kMenuItemsRadius    ((IS_IPAD) ? 55 : 30)

@protocol CuteMenuDelegate <NSObject>

-(void)pressedMenuOptionWithIndex:(NSInteger)index;
-(void)pressedSubMenuOptionWithIndex:(NSInteger)index andSubMenuIndex:(NSInteger)subIndex;

@end

@interface CuteMenu : UIView

-(id)initWithMenuStructure:(NSArray *)buttons andContainerVC:(UIViewController *)container;

-(void)show;
-(void)hide;
-(BOOL)isShown;

@property (nonatomic, weak) id<CuteMenuDelegate> delegate;

@end
