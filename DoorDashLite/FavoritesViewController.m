//
//  FavoritesViewController.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "FavoritesViewController.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantPageViewController.h"
#import "DataStore.h"

@interface FavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *favoriteRestaurants;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-address"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMap)];
    
    self.navigationItem.title = @"Favorites";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSearch)];
    
    self.restaurantsTable.dataSource = self;
    self.restaurantsTable.delegate = self;
    [self.restaurantsTable registerNib:[UINib nibWithNibName:@"RestaurantTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"restaurantCell"];
}

- (void)viewWillAppear:(BOOL)animated {    
    self.favoriteRestaurants = DataStore.sharedInstance.favoriteRestaurants;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.restaurantsTable reloadData];
    });
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteRestaurants.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    RestaurantCellTableViewCell *cell =
    //    cell.name.text = [NSString stringWithFormat:@"Restaurant %@", indexPath];
    
    RestaurantTableViewCell *restaurantCell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell"];
    NSDictionary *restaurantData = (self.favoriteRestaurants)[indexPath.row];
    restaurantCell.name.text = restaurantData[@"business"][@"name"];
    NSString *deliveryFeeText = [NSString stringWithFormat:@"$%@",restaurantData[@"delivery_fee"]];
    if ([deliveryFeeText isEqualToString:@"$0"]) {
        restaurantCell.deliveryText.text = @"Free Delivery";
    } else {
        restaurantCell.deliveryText.text = deliveryFeeText;
    }
    
    restaurantCell.deliveryTimeText.text = [NSString stringWithFormat:@"%@ min",restaurantData[@"asap_time"]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:restaurantData[@"cover_img_url"]]]];
    restaurantCell.icon.image = image;
    restaurantCell.cuisine.text = restaurantData[@"tags"][0];
    return restaurantCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showFavoriteRestaurant" sender:(self.favoriteRestaurants)[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue %@ is going to be performed", segue.identifier);
    RestaurantPageViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.restaurantData = [NSDictionary dictionaryWithDictionary:(NSDictionary *)sender];
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
