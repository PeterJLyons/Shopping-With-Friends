//
//  AppDelegate.h
//  Shopping With Friends
//
//  Created by Peter Lyons on 2/16/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSDictionary *tappedUser;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *tappedProduct;

@end

