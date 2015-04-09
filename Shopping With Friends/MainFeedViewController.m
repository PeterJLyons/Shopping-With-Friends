//
//  MainFeedViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 3/18/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "MainFeedViewController.h"
#import "AppDelegate.h"

@interface MainFeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (weak, nonatomic) IBOutlet UITableView *feedTable;

@end

@implementation MainFeedViewController
NSMutableArray *products;
AppDelegate *appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshFeed];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//in didLoad method
    // Do any additional setup after loading the view.
    //TODO: add code for loading the feed.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutUser:(id)sender {
    NSLog(@"Begin logout POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    NSMutableDictionary *tokenizer = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [pairs setValue:tokenizer[@"token"] forKey:@"token"];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/logout"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://cs2340.cdbattaglia.com/api/logout"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"token=%@",pairs[@"token"]];
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
    
    [tokenizer setValue:jsonparse[@"token"] forKey:@"token"];
    [tokenizer writeToFile:plistPath atomically:YES];
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"Logout successful.");
            [self performSegueWithIdentifier:@"logout" sender:nil];
        }
    }
}

-(void)refreshFeed
{
    NSLog(@"Begin get friends list GET...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    //NSString *email = _userField.text;
    //NSString *password = _passwordField.text;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    NSMutableDictionary *tokenizer = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [pairs setValue:tokenizer[@"token"] forKey:@"token"];
    //[pairs setValue:password forKey:@"password"];
   // NSString *friendsURL = @"http://localhost:1337/api/report/all?token=";
    
     NSString *friendsURL = @"http://cs2340.cdbattaglia.com/api/report/all?token=";
    NSString *parameters = [NSString stringWithFormat:@"%@", pairs[@"token"]];
    friendsURL = [friendsURL stringByAppendingString:parameters];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:friendsURL]];
    
    [request setHTTPMethod:@"GET"];
    
    
    //NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    //[request setHTTPBody:requestData];
    [request setTimeoutInterval:15.0];
    //NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[connection start];
    //NSLog(@"Connection started.");
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonparse = [NSJSONSerialization JSONObjectWithData:result options: NSJSONReadingMutableContainers error:&error];
    products = jsonparse[@"reports"];
    NSString *auth = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    NSLog(auth);
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"Feed retrieval successful.");
        } else {
            NSLog(@"NoFriends.");
        }
    }
    [self.feedTable reloadData];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [products count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.feedTable dequeueReusableCellWithIdentifier:@"product"];
    NSDictionary *product = [products objectAtIndex:indexPath.row];
    cell.textLabel.text = product[@"name"];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.tappedProduct = [products objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"mapView" sender:nil];
    
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
