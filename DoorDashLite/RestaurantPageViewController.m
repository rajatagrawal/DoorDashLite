//
//  RestaurantPageViewController.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "RestaurantPageViewController.h"

@interface RestaurantPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;
@property (weak, nonatomic) IBOutlet UITableView *menuItemsTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (nonatomic, assign, getter=isFavorite) BOOL favorite;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation RestaurantPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"restaurant data received is %@", self.restaurantData);
    
    self.menuItemsTable.dataSource = self;
    self.menuItemsTable.delegate = self;
    
    [self.progressIndicator setHidesWhenStopped:YES];
    
    // Do any additional setup after loading the view.
    self.favorite = NO;
    
    self.coverImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.restaurantData[@"cover_img_url"]]]];
    
    self.addToFavoritesButton.layer.borderColor = UIColor.redColor.CGColor;
    self.addToFavoritesButton.layer.borderWidth = 2;
    
    if (self.isFavorite) {
        self.addToFavoritesButton.backgroundColor = UIColor.redColor;
        [self.addToFavoritesButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.addToFavoritesButton setTitle:@"★ Favorited" forState:UIControlStateNormal];
    } else {
        self.addToFavoritesButton.backgroundColor = UIColor.whiteColor;
        [self.addToFavoritesButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [self.addToFavoritesButton setTitle:@"Add to Favorites" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *deliveryFees = [NSString stringWithFormat:@"$%@ delivery fee",self.restaurantData[@"delivery_fee"]];
    if ([deliveryFees isEqualToString:@"$0 delivery fee"]) {
        deliveryFees = @"Free Delivery";
    }
    
    NSString *deliveryTime = self.restaurantData[@"asap_time"];
    self.deliveryStatusText.text = [NSString stringWithFormat:@"%@ in %@ min", deliveryFees, deliveryTime];
    
    [self.progressIndicator startAnimating];
    [self populateMenuItems];
}

- (void)populateMenuItems {
    NSString *restaurantId = self.restaurantData[@"business"][@"id"];
    NSString *url = [NSString stringWithFormat:@"https://api.doordash.com/v2/restaurant/%@/menu", restaurantId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error retrieving results");
        } else {
            NSJSONSerialization *dataJson = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
            self.menuItems = (NSArray *)dataJson;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressIndicator stopAnimating];
                [self.menuItemsTable reloadData];
            });
            
        }
    }] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(self.menuItems[0][@"menu_categories"])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"menuOptionCell"];
    menuItemCell.textLabel.text = ((NSArray *)self.menuItems[0][@"menu_categories"])[indexPath.row][@"title"];
    return menuItemCell;
}

- (IBAction)addToFavoritesPressed:(id)sender {
    NSLog(@"Add to favorites selected");
    self.favorite = !self.isFavorite;
    if (self.isFavorite) {
        self.addToFavoritesButton.backgroundColor = UIColor.redColor;
        [self.addToFavoritesButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.addToFavoritesButton setTitle:@"★ Favorited" forState:UIControlStateNormal];
    } else {
        self.addToFavoritesButton.backgroundColor = UIColor.whiteColor;
        [self.addToFavoritesButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [self.addToFavoritesButton setTitle:@"Add to Favorites" forState:UIControlStateNormal];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
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
