//
//  TweetCell.h
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/27/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (void)configureCellWithTweet:(Tweet *)tweet;
- (void)refreshView:(Tweet *)tweet;
+ (NSString *)identifier;

@end
