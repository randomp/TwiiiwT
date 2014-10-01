//
//  TimelineViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/26/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIView+Superview.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TweetCell *prototypeCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    [self.tweetTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:[TweetCell identifier]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView addSubview:self.refreshControl];
    
    [self setUpNavigationBar];
    
    [self getTweets];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tweetTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TweetCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tweetTableView dequeueReusableCellWithIdentifier:[TweetCell identifier]];
    }
    return _prototypeCell;
}

- (void)refresh:(id)sender {
    [self getTweets];
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)getTweets {
    [[TwitterClient instance] homeTimelineWithParams:nil success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tweetTableView reloadData];
        /*for (Tweet *tweet in self.tweets) {
            NSLog(@"tweet user: %@", tweet.user.name);
            NSLog(@"tweet original user: %@", tweet.originalUser.name);
            NSLog(@"tweet: %@", tweet.text);
        }*/
        NSLog(@"initilize success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error.description);
    }];
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = (TweetCell*) [tableView dequeueReusableCellWithIdentifier:[TweetCell identifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[TweetCell alloc] init];
    }
    [cell configureCellWithTweet:self.tweets[indexPath.row]];
    [cell.replyButton addTarget:self action:@selector(onClickReplyButton:) forControlEvents:UIControlEventTouchDown];
    [cell.retweetButton addTarget:self action:@selector(onClickRetweetButton:) forControlEvents:UIControlEventTouchDown];
    [cell.favoriteButton addTarget:self action:@selector(onClickFavouriteButton:) forControlEvents:UIControlEventTouchDown];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.prototypeCell configureCellWithTweet:self.tweets[indexPath.row]];
    [self.prototypeCell layoutSubviews];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TweetViewController *tvc = [[TweetViewController alloc] init];
    tvc.tweet = [self.tweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.tweets count] - 1) //self.array is the array of items you are displaying
    {
        [self getTweets];
    }
}

#pragma mark - ComposeViewController delegate
- (void)updateWithNewTweet:(Tweet*) tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tweetTableView reloadData];
}

#pragma mark - Click on navigationbar button

- (void)onClickComposeButton {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.myDelegate = self;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)onClickSignOutButton {
    [User signOut];
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
}

#pragma mark - Click on buttons
- (void)onClickReplyButton:(id)sender {
    TweetCell *cell = (TweetCell *) [sender findSuperviewOfClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:cell];
    Tweet *tweet = (Tweet *)self.tweets[indexPath.row];
    
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.myDelegate = self;
    cvc.replyToScreenName = tweet.user.screenName;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)onClickRetweetButton:(id)sender {
    TweetCell *cell = (TweetCell *) [sender findSuperviewOfClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:cell];
    Tweet *tweet = (Tweet *)self.tweets[indexPath.row];
    TwitterClient *client = [TwitterClient instance];
    if (tweet.retweeted) {
        NSNumber *retweetID = tweet.tweetID;
        /*if (tweet.retweetedStatus) {
            retweetID = tweet.retweetedStatus.tweetID;
        }*/
        [client destroyWithId:tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on retweet button, destroy reweet success");
            tweet.retweeted = NO;
            tweet.retweetCount -= 1;
            // update retweeted_status
            //tweet.retweetedStatus = [[Tweet alloc] initWithDictionary:responseObject];
            [cell refreshView:tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on retweet button, destroy retweet fail, %@", error.description);
        }];
    } else {
        [client retweetWithId:tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on retweet button, reweet success");
            NSLog(@"response: %@", responseObject);
            tweet.retweeted = YES;
            tweet.retweetCount += 1;
            [cell refreshView:tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on retweet button, retweet fail, %@", error.description);
        }];
    }
}

- (void)onClickFavouriteButton:(id)sender {
    TweetCell *cell = (TweetCell *) [sender findSuperviewOfClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:cell];
    Tweet *tweet = (Tweet *)self.tweets[indexPath.row];
    TwitterClient *client = [TwitterClient instance];
    if (tweet.favorited) {
        [client removeFavoriteWithId:tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on favourite button, remove favourite success");
            tweet.favorited = NO;
            tweet.favouritesCount -= 1;
            [cell refreshView:tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on favourite button, remove favourite fail, %@", error.description);
        }];
    } else {
        [client favoriteWithId:tweet.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Click on favourite button, add favourite success");
            tweet.favorited = YES;
            tweet.favouritesCount += 1;
            [cell refreshView:tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Click on favourite button, add favourite fail");
        }];
    }
}

#pragma mark - Set up UI
- (void)setUpNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:127.0f/255.0f green:195.0f/255.0f blue:1.0f alpha:1.0f];
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"composeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickComposeButton)];
    
    //UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(onClickSignOutButton)];
    self.navigationItem.rightBarButtonItem = composeButton;
    self.navigationItem.leftBarButtonItem = signOutButton;
}

@end
