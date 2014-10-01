//
//  TweetCell.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/27/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "TweetCell.h"
#import "Utils.h"
#import "NSDate+DateTools.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetViewTopSpace;

@end

@implementation TweetCell
@synthesize textLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTweet:(Tweet *)tweet {
    self.tweet = tweet;
    [Utils loadImageUrl:[tweet author].profileImageUrl inImageView:self.profileImageView withAnimation:YES];
    self.nameLabel.text = [tweet author].name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@",[tweet author].screenName];
    self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.textLabel.text = tweet.text;
    
    if (tweet.originalUser) {
        self.retweetView.hidden = NO;
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        [self.profileImageViewTopSpace setConstant:20.0f];
        [self.tweetViewTopSpace setConstant:20.0f];
    } else {
        self.retweetView.hidden = YES;
        [self.profileImageViewTopSpace setConstant:5.0f];
        [self.tweetViewTopSpace setConstant:5.0f];
    }
    
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"replyIcon"] forState:UIControlStateNormal];
    
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"reTweetIcon"] forState:UIControlStateNormal];
    
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteIcon"] forState:UIControlStateNormal];
    
    [self refreshView:tweet];
}

- (void)refreshView:(Tweet *)tweet {
    if (tweet.retweeted) {
        [self.retweetButton setAlpha:0.5f];
    } else {
        [self.retweetButton setAlpha:1.0f];
    }
    if (tweet.favorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteSelectedIcon"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteIcon"] forState:UIControlStateNormal];
    }
}

+ (NSString *)identifier {
    return @"TweetCell";
}

@end
