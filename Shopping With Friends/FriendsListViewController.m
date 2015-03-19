//
//  FriendsListViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 3/18/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "FriendsListViewController.h"
#import "AppDelegate.h"

@interface FriendsListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UITableView *friendsList;


@end

@implementation FriendsListViewController
AppDelegate *appDelegate;
NSMutableArray *friends;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//in didLoad method
    
    
    NSLog(@"Begin get friends list GET...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    //NSString *email = _userField.text;
    //NSString *password = _passwordField.text;
    [pairs setValue:appDelegate.userToken forKey:@"token"];
    //[pairs setValue:password forKey:@"password"];
    NSString *friendsURL = @"http://localhost:1337/api/user/friends?token=";
    NSString * parameters = [NSString stringWithFormat:pairs[@"token"]];
    friendsURL = [friendsURL stringByAppendingString:parameters];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:friendsURL]];
    
    [request setHTTPMethod:@"GET"];
    
    
    //NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    //[request setHTTPBody:requestData];
    [request setTimeoutInterval:15.0];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    NSLog(@"Connection started.");
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonparse = [NSJSONSerialization JSONObjectWithData:result options: NSJSONReadingMutableContainers error:&error];
    friends = jsonparse[@"friends"];
    NSString *auth = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    //NSLog(auth);
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"Friends list retrieval successful.");
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFriendAlert:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Type your friend's email!" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"Entered Email:",[[alertView textFieldAtIndex:0] text]);
    NSString *friendEmail = [[alertView textFieldAtIndex:0] text];
    NSLog(@"Begin add Friend POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    //NSString *email = _userField.text;
    //NSString *password = _passwordField.text;
    [pairs setValue:appDelegate.userToken forKey:@"token"];
    //[pairs setValue:password forKey:@"password"];
    [pairs setValue:friendEmail forKey:@"friendemail"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/user/add_friend"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"token=%@&friend_email=%@",pairs[@"token"],pairs[@"friendemail"]];
    NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    [request setHTTPBody:requestData];
    [request setTimeoutInterval:15.0];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    NSLog(@"Connection started.");
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonparse = [NSJSONSerialization JSONObjectWithData:result options: NSJSONReadingMutableContainers error:&error];
    NSString *auth = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    //NSLog(auth);
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"Add friend successful.");
        }
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.friendsList dequeueReusableCellWithIdentifier:@"friend"];
    NSDictionary *friend = [friends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend[@"full_name"];
     
     return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
