//
//  DataStore.h
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataStore : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) NSMutableArray *favoriteRestaurants;

@end
