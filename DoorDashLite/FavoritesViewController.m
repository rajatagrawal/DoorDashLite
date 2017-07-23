//
//  FavoritesViewController.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-address"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMap)];
    
    self.navigationItem.title = @"Door Dash";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSearch)];
}

- (void)showMap {
    NSLog(@"Show map");
    UIViewController *showAddressViewController = [[UIStoryboard storyboardWithName:@"Main"
                                                                             bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:showAddressViewController animated:YES completion:nil];
}

- (void)showSearch {
    NSLog(@"Show search");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
