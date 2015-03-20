//
//  FriendDetailViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 3/19/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "AppDelegate.h"

@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Email;
@property (weak, nonatomic) IBOutlet UILabel *Rating;
@property (weak, nonatomic) IBOutlet UILabel *ReportCount;

@end

@implementation FriendDetailViewController
AppDelegate *appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//in didLoad method
    [_Name setText:appDelegate.tappedUser[@"full_name"]];
    [_Email setText:appDelegate.tappedUser[@"email"]];
    [_Rating setText:[NSString stringWithFormat:@"%@", appDelegate.tappedUser[@"rating"]]];
    [_ReportCount setText:[NSString stringWithFormat:@"%@", appDelegate.tappedUser[@"reportCount"]]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteFriend:(id)sender {
    NSLog(@"Begin remove friend POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    NSMutableDictionary *tokenizer = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [pairs setValue:tokenizer[@"token"] forKey:@"token"];
    [pairs setValue:appDelegate.tappedUser[@"email"] forKey:@"friend_email"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/user/remove_friend"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"token=%@&friend_email=%@",pairs[@"token"],pairs[@"friend_email"]];
    NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    [request setHTTPBody:requestData];
    [request setTimeoutInterval:15.0];
    //NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[connection start];
    //NSLog(@"Connection started.");
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonparse = [NSJSONSerialization JSONObjectWithData:result options: NSJSONReadingMutableContainers error:&error];
    NSString *auth = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    NSLog(auth);
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"remove friend successful.");
            appDelegate.userToken = jsonparse[@"token"];
            [self performSegueWithIdentifier:@"back" sender:nil];
        }
    }

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
