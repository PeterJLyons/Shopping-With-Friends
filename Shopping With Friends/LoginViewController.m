//
//  LoginViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 2/24/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "LoginViewController.h"
@import Foundation;


@interface LoginViewController () <NSURLConnectionDataDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *attemptLogin;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [_userField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    _userField.delegate = self;
    _passwordField.delegate = self;
    
    
    //in didLoad method
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}


- (IBAction)tryLogin:(id)sender {
    
    NSLog(@"Begin login POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    NSString *email = _userField.text;
    NSString *password = _passwordField.text;
    [pairs setValue:email forKey:@"email"];
    [pairs setValue:password forKey:@"password"];
    
    //Uncomment for local node server
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/login"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://cs2340.cdbattaglia.com/api/login"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"email=%@&password=%@",pairs[@"email"],pairs[@"password"]];
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"]; // Correct path to Documents Dir in the App Sand box
   /* NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];*/
   
    NSMutableDictionary *tokenizer = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    if (tokenizer == nil)
    {
         tokenizer = [[NSMutableDictionary alloc] init];
    }
    NSString *tok = jsonparse[@"token"];
    [tokenizer setObject:tok forKey:@"token"];
    [tokenizer writeToFile:plistPath atomically:YES];
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"Login successful.");
            
            [self performSegueWithIdentifier:@"login_success" sender:nil];
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
