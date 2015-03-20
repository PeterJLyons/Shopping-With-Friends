//
//  ReportSaleViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 3/19/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "ReportSaleViewController.h"

@interface ReportSaleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *latField;
@property (weak, nonatomic) IBOutlet UITextField *longField;

@end

@implementation ReportSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reportSale:(id)sender {
    NSString *name = _nameField.text;
    NSString *price = _priceField.text;
    NSString *lat = _latField.text;
    NSString *longit = _longField.text;
    NSLog(@"Begin report sale POST...\n");
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    NSMutableDictionary *tokenizer = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [pairs setValue:tokenizer[@"token"] forKey:@"token"];
    [pairs setValue:name forKey:@"name"];
    [pairs setValue:price forKey:@"price"];
    [pairs setValue:lat forKey:@"lat"];
    [pairs setValue:longit forKey:@"long"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/api/report/new"]];
    
    [request setHTTPMethod:@"POST"];
    NSString * parameters = [NSString stringWithFormat:@"token=%@&name=%@&price=%@&long=%@&lat=%@",pairs[@"token"],pairs[@"name"],pairs[@"price"],pairs[@"lat"],pairs[@"long"]];
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
    //NSLog(auth);
    if (![auth isEqualToString:@"Unauthorized"])
    {
        if ([jsonparse[@"status"] isEqualToString:@"success"]) {
            NSLog(@"report sale successful.");
        }
    }
    
    [self performSegueWithIdentifier:@"report_success" sender:nil];

    
    
    
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
