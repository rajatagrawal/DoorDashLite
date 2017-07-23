//
//  FirstViewController.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/22/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"tab-explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = selectedImage;
    
    NSLog(@"First view controller did load");
    UIImage *chooseAddressImage = [UIImage imageNamed:@"nav-address"];
    self.navigationItem.title = @"acha ho gaya";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"aiyo" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"aiyo" style:UIBarButtonItemStylePlain target:nil action:nil];
    /*
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:chooseAddressImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
