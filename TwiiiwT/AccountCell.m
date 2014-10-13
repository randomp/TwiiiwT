//
//  AccountCell.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/12/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "AccountCell.h"
#import "Utils.h"

@interface AccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;


@end

@implementation AccountCell

@synthesize profileImageView;

- (void)awakeFromNib {
    // Initialization code
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    [Utils loadImageUrl:user.profileImageUrl inImageView:self.profileImageView withAnimation:NO];
    self.nameLabel.text = user.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
}

+ (NSString *)identifier {
    return @"AccountCell";
}

@end
