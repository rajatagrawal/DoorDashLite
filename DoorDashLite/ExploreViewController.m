//
//  ExploreViewController.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "ExploreViewController.h"
#import "RestaurantTableViewCell.h"
#import "DataStore.h"
#import "RestaurantPageViewController.h"
#import <MapKit/MapKit.h>

@interface ExploreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *restaurantsTable;
@property (nonatomic, strong) NSJSONSerialization *results;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantsTable.delegate = self;
    self.restaurantsTable.dataSource = self;
    [self.restaurantsTable registerNib:[UINib nibWithNibName:@"RestaurantTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"restaurantCell"];
    
    // Set navigation left bar button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-address"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMap)];
    
    self.navigationItem.title = @"Door Dash";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSearch)];
    
    self.coordinates = CLLocationCoordinate2DMake(0, 0);
    [self.progressIndicator setHidesWhenStopped:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    if ((self.coordinates.longitude != DataStore.sharedInstance.currentLocation.longitude) || (self.coordinates.longitude != DataStore.sharedInstance.currentLocation.longitude)) {
        self.coordinates = DataStore.sharedInstance.currentLocation;
        
        [self.progressIndicator startAnimating];
        
        NSString *url = [NSString stringWithFormat:@"https://api.doordash.com/v1/store_search/?lat=%lf&lng=%lf",DataStore.sharedInstance.currentLocation.latitude, DataStore.sharedInstance.currentLocation.longitude];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            
            if (error) {
                NSLog(@"There was an error retrieving results");
                UIAlertController *errorController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [errorController addAction:[UIAlertAction actionWithTitle:@"Dismiss"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
                [self presentViewController:errorController animated:YES completion:nil];
            } else {
                NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                
                NSJSONSerialization *dataJson = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
                self.results = dataJson;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressIndicator stopAnimating];
                    [self.restaurantsTable reloadData];
                });
            }
        }] resume];
    }
}

- (void)showMap {
    UIViewController *showAddressViewController = [[UIStoryboard storyboardWithName:@"Main"
                                                                             bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [self presentViewController:showAddressViewController animated:YES completion:nil];
    NSLog(@"Show map");
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
    return [((NSArray *)self.results) count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    RestaurantCellTableViewCell *cell =
//    cell.name.text = [NSString stringWithFormat:@"Restaurant %@", indexPath];
    
    RestaurantTableViewCell *restaurantCell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell"];
    NSDictionary *restaurantData = ((NSArray *)self.results)[indexPath.row];
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
    [self performSegueWithIdentifier:@"showRestaurantPage" sender:((NSArray *)self.results)[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue %@ is going to be performed", segue.identifier);
    RestaurantPageViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.restaurantData = [NSDictionary dictionaryWithDictionary:(NSDictionary *)sender];
}
//- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    NSLog(@"Segue is going to be performed for %@ %@", sender, identifier);

//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
