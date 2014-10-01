//
//  LoginViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/24/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import <pop/POP.h>
#import "TSMessage.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (assign) BOOL loginSuccess;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginButton.hidden = YES;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 0.5f;
    self.loginButton.layer.cornerRadius = 4.0f;
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.5f, 1.5f)];
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 0.5f;
    [self.logoImageView pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    if ([User currentUser]!=nil) {
        [User verifyCurrentUserWithSuccess:^{
            NSLog(@"Login success");
            self.loginSuccess = YES;
            TimelineViewController *tvc = [[TimelineViewController alloc] init];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
            [self presentViewController:nvc animated:YES completion:nil];
        }failure:^(NSError *error) {
            self.loginButton.hidden = NO;
        }];
    } else {
        self.loginButton.hidden = NO;
    }
    /*TimelineViewController *tvc = [[TimelineViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:nvc animated:YES completion:nil];
    if (self.loginSuccess) {
        NSLog(@"present");
        TimelineViewController *tvc = [[TimelineViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        [self presentViewController:nvc animated:YES completion:nil];
    }*/
}

/*- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    NSLog(@"prepare to present");
    if (self.loginSuccess) {
        NSLog(@"present");
        TimelineViewController *tvc = [[TimelineViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        [self presentViewController:nvc animated:YES completion:nil];
    }
    [super viewDidAppear:animated];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickLoginButton:(id)sender {
    [[TwitterClient instance] login];
}

@end
