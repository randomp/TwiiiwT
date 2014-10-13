//
//  MenuCell.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (strong, nonatomic) UIViewController *menuItem;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)setMenuItem:(UIViewController *)menuItem;

+ (NSString *)identifier;

@end
