//
//  AccountCell.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) User *user;

+ (NSString *)identifier;
@end
