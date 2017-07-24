//
//  DataStore.m
//  DoorDashLite
//
//  Created by Rajat Agrawal on 7/23/17.
//  Copyright © 2017 Rajat Agrawal. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (instancetype)sharedInstance {
    static DataStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.currentLocation = CLLocationCoordinate2DMake(0, 0);
    });
    return instance;
}
@end
