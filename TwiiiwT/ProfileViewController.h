//
//  ProfileViewController.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/10/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) User *user;

@end
