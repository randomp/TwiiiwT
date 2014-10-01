//
//  TweetViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/29/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Utils.h"
#import "User.h"
#import "Tweet.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UIView *retweetView;
@property (weak, nonatomic) IBOutlet UILabel *retweetUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopSpace;
@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:127.0f/255.0f green:195.0f/255.0f blue:1.0f alpha:1.0f];
    self.navigationItem.title = @"Tweet";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // TODO: cache this
    [Utils loadImageUrl:[self.tweet author].profileImageUrl inImageView:self.profileImageView withAnimation:YES];
    self.nameLabel.text = [self.tweet author].name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@",[self.tweet author].screenName];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
    self.timeLabel.text = [dateFormat stringFromDate:self.tweet.createdAt ];
    self.textLabel.text = self.tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favouriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favouritesCount];
    
    if (self.tweet.originalUser) {
        self.retweetUserLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweetView.hidden = NO;
        //[self.profileImageViewTopSpace setConstant:55.0f];
        //[self.nameLabelTopSpace setConstant:55.0f];
    } else {
        self.retweetView.hidden = YES;
        [self.profileImageViewTopSpace setConstant:65.0f];
        [self.nameLabelTopSpace setConstant:65.0f];
    }
    
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"replyIcon"] forState:UIControlStateNormal];
    
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"reTweetIcon"] forState:UIControlStateNormal];
    
    [self.favouriteButton setTitle:@"" forState:UIControlStateNormal];
    [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteIcon"] forState:UIControlStateNormal];
    
    [self.replyButton addTarget:self action:@selector(onClickReplyButton:) forControlEvents:UIControlEventTouchDown];
    [self.retweetButton addTarget:self action:@selector(onClickRetweetButton:) forControlEvents:UIControlEventTouchDown];
    [self.favouriteButton addTarget:self action:@selector(onClickFavouriteButton:) forControlEvents:UIControlEventTouchDown];
    
    [self refreshView:self.tweet];
}

- (void)refreshView:(Tweet *)tweet {
    if (tweet.retweeted) {
        [self.retweetButton setAlpha:0.5f];
    } else {
        [self.retweetButton setAlpha:1.0f];
    }
    if (tweet.favorited) {
        [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteSelectedIcon"] forState:UIControlStateNormal];
    } else {
        [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"favoriteIcon"] forState:UIControlStateNormal];
    }
}

#pragma mark - Click on buttons
- (void)onClickReplyButton:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.myDelegate = self;
    cvc.replyToScreenName = self.tweet.user.screenName;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)onClickRetweetButton:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    if (self.tweet.retweeted) {
        NSNumber *retweetID = self.tweet.tweetID;
        /*if (tweet.retweetedStatus) {
         retweetID = tweet.retweetedStatus.tweetID;
         }*/
        [client destroyWithId:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on retweet button, destroy reweet success");
            self.tweet.retweeted = NO;
            self.tweet.retweetCount -= 1;
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            // update retweeted_status
            //tweet.retweetedStatus = [[Tweet alloc] initWithDictionary:responseObject];
            [self refreshView:self.tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on retweet button, destroy retweet fail, %@", error.description);
        }];
    } else {
        [client retweetWithId:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on retweet button, reweet success");
            self.tweet.retweeted = YES;
            self.tweet.retweetCount += 1;
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            [self refreshView:self.tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on retweet button, retweet fail, %@", error.description);
        }];
    }
}

- (void)onClickFavouriteButton:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    if (self.tweet.favorited) {
        [client removeFavoriteWithId:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on favourite button, remove favourite success");
            NSLog(@"response: %@", responseObject);
            self.tweet.favorited = NO;
            self.tweet.favouritesCount -= 1;
            self.favouriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favouritesCount];
            [self refreshView:self.tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on favourite button, remove favourite fail, %@", error.description);
        }];
    } else {
        [client favoriteWithId:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on favourite button, add favourite success");
            self.tweet.favorited = YES;
            self.tweet.favouritesCount += 1;
            self.favouriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favouritesCount];
            [self refreshView:self.tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on favourite button, add favourite fail");
        }];
    }
}


@end
