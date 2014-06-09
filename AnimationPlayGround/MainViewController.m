//
//  MainViewController.m
//  CuteMenu
//
//  Created by Marcos Espada Vázquez on 19/04/14.
//  Copyright (c) 2014 Marcos Espada Vázquez. All rights reserved.
//

#import "MainViewController.h"
#import "CuteMenu.h"

static NSArray *kMenuStruct = nil;

@interface MainViewController () <CuteMenuDelegate>

@property (nonatomic, strong) CuteMenu *menu;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        kMenuStruct = @[@{@"title"      : @"Basic",
                          @"controller" : @"",
                          @"submenu"    : @[@{@"title":@"PoP#1", @"controller":@"PoP1BasicViewController"},
                                            @{@"title":@"PoP#2", @"controller":@"PoP2BasicViewController"}]
                          },
                        @{@"title"      : @"Advanced",
                          @"controller" : @"",
                          @"submenu"    : @[@{@"title":@"PoP#1", @"controller":@"PoP1AdvancedViewController"},
                                            @{@"title":@"PoP#2", @"controller":@"PoP2AdvancedViewController"}
                                            ]
                          },
                        @{@"title"      : @"Example",
                          @"controller" : @"",
                          @"submenu"    : @[@{@"title":@"Example#1", @"controller":@"AutoLayoutExampleViewController"}]
                          }
                        ];
    }
    return self;
}

-(void)loadView {
    self.view = [MainView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeContactAdd];
    menu.frame = CGRectMake(80, 80, 30, 30);
    [menu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBut = [[UIBarButtonItem alloc] initWithCustomView:menu];
    self.navigationItem.leftBarButtonItem = barBut;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.text = @"Press the '+' to open/close the menu.\n LongPress the Home button to move the menu around.";
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self.view addSubview:label];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)showMenu:(id)sender {
    if ( !self.menu ) {
        self.menu = [[CuteMenu alloc]
                     initWithMenuStructure:kMenuStruct
                     andContainerVC:self];
        self.menu.delegate = self;
    }
    
    if ( [self.menu isShown] ) {
        [self.menu hide];
    } else {
        [self.menu show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CuteMenu Delegate

-(void)pressedMenuOptionWithIndex:(NSInteger)index {
    UIViewController *vC = [UIViewController new];
    vC.title = kMenuStruct[index][@"title"];
    vC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255.)/255. green:arc4random_uniform(255.)/255. blue:arc4random_uniform(255.)/255. alpha:1];
    [self.navigationController pushViewController:vC animated:YES];
    
}

-(void)pressedSubMenuOptionWithIndex:(NSInteger)index andSubMenuIndex:(NSInteger)subIndex {
    NSString *controller = kMenuStruct[index][@"submenu"][subIndex][@"controller"];
    UIViewController *vC;
    if ( controller.length > 0 ) {
        vC = [[NSClassFromString(controller) alloc] init];
    } else {
        vC = [UIViewController new];
    }
    
    vC.title = kMenuStruct[index][@"submenu"][subIndex][@"title"];
    vC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vC animated:YES];
}

@end
