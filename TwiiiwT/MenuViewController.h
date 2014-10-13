//
//  MenuViewController.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *menuItems;

@end
