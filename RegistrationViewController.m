//
//  RegistrationViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 3/17/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController () <NSURLConnectionDataDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *FullName;
@property (weak, nonatomic) IBOutlet UITextField *EmailField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmEmail;
@property (weak, nonatomic) IBOutlet UITextField *UsernameField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (nonatomic, assign) id currentResponder;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    _FullName.delegate = self;
    _EmailField.delegate = self;
    _ConfirmEmail.delegate = self;
    _UsernameField.delegate = self;
    _PasswordField.delegate = self;
    _ConfirmPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //NSLog(@"Done Editing.");
}

- (IBAction)TryRegistration:(id)sender {

    NSLog(@"Begin Registration POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    NSString *email = _EmailField.text;
    NSString *password = _PasswordField.text;
    NSString *fullName = _FullName.text;
    NSString *userName = _UsernameField.text;
    [pairs setValue:fullName forKey:@"full_name"];
    [pairs setValue:email forKey:@"email"];
    [pairs setValue:userName forKey:@"username"];
    [pairs setValue:password forKey:@"password"];
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/register"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"full_name=%@&email=%@&username=%@&password=%@",pairs[@"full_name"],pairs[@"email"],pairs[@"username"],pairs[@"password"]];
    NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    [request setHTTPBody:requestData];
    [request setTimeoutInterval:15.0];
    //NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[connection start];
    //NSLog(@"Connection started.");
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *dict = [response allHeaderFields];
    NSLog(@"Status code: %ld",(long)[response statusCode]);
    NSLog(@"Headers:\n %@",dict.description);
    NSLog(@"Error: %@",error.description);
    
    NSDictionary *jsonparse = [NSJSONSerialization JSONObjectWithData:result options: NSJSONReadingMutableContainers error:&error];
   
    //NSLog(@"Response data: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSString *auth = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    NSLog(@"Data result:");
    NSLog(auth);
    
    if ([jsonparse[@"status"] isEqualToString:@"success"])
    {
        NSLog(@"Registration successful.");
        [self performSegueWithIdentifier:@"register_success" sender:nil];
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
