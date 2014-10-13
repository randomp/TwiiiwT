//
//  ProfileCell.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 10/10/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "ProfileCell.h"
#import "Utils.h"
#import "UIImage+ImageEffects.h"
#import "GPUImage.h"


@interface ProfileCell () {
    UIImage *sourceImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *bannerImage;
@end

@implementation ProfileCell

@synthesize profileImageView;

- (void)awakeFromNib {
    // Initialization code
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onScrollDistanceChanged:)
                                                 name:@"distanceChanged"
                                               object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithUser:(User *)user {
    self.user = user;
    [Utils loadImageUrl:user.profileImageUrl inImageView:self.profileImageView withAnimation:NO];
    if (self.isDescription) {
        self.profileImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.screennameLabel.hidden = NO;
        self.locationLabel.hidden = YES;
        self.nameLabel.text = self.user.name;
        self.screennameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    } else {
        self.profileImageView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.screennameLabel.hidden = YES;
        self.locationLabel.hidden = NO;
        self.locationLabel.text = self.user.place;
    }
    if (self.user.bannerImageUrl != nil && self.bannerImage == nil) {
        self.bannerImage = [[UIImageView alloc] init];
        self.bannerImage.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        self.bannerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.profileImageView.clipsToBounds = YES;
        [Utils loadImageUrl:self.user.bannerImageUrl inImageView:self.bannerImage withAnimation:NO withSuccess:^{
            sourceImage = self.bannerImage.image;
            UIColor *tintColor = [UIColor colorWithWhite:0.1f alpha:0.3f];
            self.bannerImage.image = [sourceImage applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
        }];
        [self addSubview:self.bannerImage];
        [self sendSubviewToBack:self.bannerImage];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)onScrollDistanceChanged:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"distanceChanged"]) {
        if (self.bannerImage) {
            NSLog(@"scroll");
            NSNumber *distanceNumber = [notification valueForKey:@"object"];
            CGFloat distance = abs([distanceNumber floatValue]);
            UIColor *tintColor = [UIColor colorWithWhite:0.1 alpha:0.3];
            self.bannerImage.image = [sourceImage applyBlurWithRadius:distance tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
            CGRect newFrame = self.bannerImage.frame;
            newFrame.origin.y = -distance;
            newFrame.size.height = 155 + distance;
            self.bannerImage.frame = newFrame;
        }
    }
}

+ (NSString *)identifier {
    return @"ProfileCell";
}

@end
