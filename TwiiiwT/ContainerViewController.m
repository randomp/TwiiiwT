//
//  ContainerViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarView;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSelectMenuItem:)
                                                     name:@"menuSelected"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UINavigationController*) navigationController {
    if(_navigationController == nil) {
        _navigationController = [[UINavigationController alloc] init];
    }
    return _navigationController;
}

- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void) onSelectMenuItem:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"menuSelected"]) {
        [self.navigationController setViewControllers:@[(UIViewController *)notification.object]];
        [self displayContentController:self.navigationController];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:195.0f/255.0f blue:1.0f alpha:1.0f];
    
    [self.navigationController setViewControllers:@[self.viewControllers[0]]];
    [self displayContentController:self.navigationController];
        
    UITabBarItem *home = [[UITabBarItem alloc] initWithTitle:@"Timeline" image:[UIImage imageNamed:@"homeIcon"] tag:0];
    UITabBarItem *profile = [[UITabBarItem alloc] initWithTitle:@"About Me" image:[UIImage imageNamed:@"aboutMe"] tag:1];
    self.tabBarView.tintColor = [UIColor colorWithRed:117.0/255.0 green:135.0/255.0 blue:149.0/255.0 alpha:1];
    self.tabBarView.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:195.0f/255.0f blue:1.0f alpha:1.0f];
    [self.tabBarView setItems:@[home, profile] animated:YES];
    self.tabBarView.delegate = self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self.navigationController setViewControllers:@[self.viewControllers[item.tag]]];
    [self displayContentController:self.navigationController];
}

@end
