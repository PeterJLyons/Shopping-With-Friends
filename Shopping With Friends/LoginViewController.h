//
//  LoginViewController.h
//  Shopping With Friends
//
//  Created by Peter Lyons on 2/24/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <NSURLConnectionDataDelegate>
@property (nonatomic, retain) NSMutableData *responseData;
@end
