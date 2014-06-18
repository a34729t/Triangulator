//
//  BeaconManager.h
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//


@import CoreBluetooth;
@import CoreLocation;
#import <Foundation/Foundation.h>
#import "Config.h"

@class BeaconManager;

@protocol BeaconManagerDelegate <NSObject>

- (void)discoveredBeaconWithMajor:(NSString *)major minor:(NSString *)minor proximity:(CLProximity)proximity;

@end

@interface BeaconManager : NSObject

@property(nonatomic) id <BeaconManagerDelegate> delegate;
+ (BeaconManager*)sharedInstance;
- (void)start;
- (void)stop;
@end