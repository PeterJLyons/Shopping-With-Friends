//
//  ProductMapViewController.m
//  Shopping With Friends
//
//  Created by Peter Lyons on 4/5/15.
//  Copyright (c) 2015 CS2340. All rights reserved.
//

#import "ProductMapViewController.h"
#import "AppDelegate.h"
#define METERS_PER_MILE 1609.344

@implementation ProductMapViewController
AppDelegate *appDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];//in didLoad method
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    
    NSMutableArray *loc = appDelegate.tappedProduct[@"location"];
    NSNumber *lat = loc[1];
    NSNumber *longit = loc[0];
    double latitude = [lat doubleValue];
    double longitude = [longit doubleValue];
    zoomLocation.latitude = latitude;
    zoomLocation.longitude= longitude;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = zoomLocation;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_theMap setRegion:viewRegion animated:YES];
    [_theMap addAnnotation:point];
}


@end
