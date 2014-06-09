//
//  AutoLayoutExampleViewController.m
//  AnimationPlayGround
//
//  Created by Marcos Espada Vazquez on 14/05/14.
//  Copyright (c) 2014 mobgen. All rights reserved.
//

#import "AutoLayoutExampleViewController.h"

@interface AutoLayoutExampleViewController ()

@end

@implementation AutoLayoutExampleViewController

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
    self.view = [AutoLayoutExampleView new];
    [self.view updateConstraintsIfNeeded];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
