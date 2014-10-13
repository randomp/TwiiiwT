//
//  MenuCell.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize textLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuItem:(UIViewController *)menuItem {
    [self.textLabel setText:menuItem.title];
}

+ (NSString *)identifier {
    return @"MenuCell";
}

@end
