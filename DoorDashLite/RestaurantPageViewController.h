//
//  RestaurantPageViewController.h
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *deliveryStatusText;
@property (nonatomic, strong) NSDictionary *restaurantData;
@end
