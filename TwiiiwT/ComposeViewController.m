//
//  ComposeViewController.m
//  TwiiiwT
//
//  Created by Peiqi Zheng on 9/30/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Utils.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

@synthesize myDelegate;

static NSString *placeHolder = @"What's hapenning?";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.delegate = self;
    self.textView.text = placeHolder;
    self.textView.textColor = [UIColor lightGrayColor];
    [self setUpUI];
    if (self.replyToScreenName != nil) {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.replyToScreenName];
        [self.textView becomeFirstResponder];
        //self.countLabel.text = [NSString stringWithFormat:@"%i",140-self.textView.text.length];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:placeHolder]) {
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = placeHolder;
        self.textView.textColor = [UIColor lightGrayColor];
    }
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    int len = self.textView.text.length;
    self.countLabel.text=[NSString stringWithFormat:@"%i",140-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([self.textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[self.textView text] length] > 139)
    {
        return NO;
    }
    return YES;
}

- (void)onClickTweetButton {
    Tweet *tweet = [[Tweet alloc] init];
    tweet.user = [User currentUser];
    tweet.originalUser = nil;
    tweet.createdAt = [NSDate date];
    tweet.text = self.textView.text;
    tweet.retweetCount = 0;
    tweet.favouritesCount = 0;
    tweet.favorited = NO;
    tweet.retweeted = NO;
    [[TwitterClient instance] updateWithStatus:self.textView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Update tweet success");
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.myDelegate respondsToSelector:@selector(updateWithNewTweet:)]) {
            [self.myDelegate updateWithNewTweet:tweet];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Update tweet fail: %@", error.description);
    }];
}

- (void)setUpUI {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:127.0f/255.0f green:195.0f/255.0f blue:1.0f alpha:1.0f];
    self.navigationItem.title = @"Compose";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [Utils loadImageUrl:[User currentUser].profileImageUrl inImageView:self.profileImageView withAnimation:YES];
    self.nameLabel.text = [User currentUser].name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@",[User currentUser].screenName];
    
    UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tButton setBackgroundColor:[UIColor clearColor]];
    [tButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [tButton.layer setBorderWidth:0.5f];
    [tButton.layer setCornerRadius:4.0f];
    tButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [tButton addTarget:self action:@selector(onClickTweetButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithCustomView:tButton];
    self.navigationItem.rightBarButtonItem = mapButton;
}
@end
