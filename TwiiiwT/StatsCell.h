//
//  StatsCell.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/11/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface StatsCell : UITableViewCell

@property (strong, nonatomic) User *user;

+ (NSString *)identifier;

@end
