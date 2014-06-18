//
//  BeaconManager.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "BeaconManager.h"

@interface BeaconManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableSet *registeredBeaconMajor;

@end

@implementation BeaconManager

+ (BeaconManager *)sharedInstance
{
    static dispatch_once_t once=0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init{
    if (self=[super init]) {
        // Initialize location manager and set ourselves as the delegate
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // HACK ALERT: Hardcode our beacons into the app (but just the major)
        self.registeredBeaconMajor = [[NSMutableSet alloc] initWithArray:@[BEACON_BLUE_MAJOR, BEACON_GREEN_MAJOR, BEACON_PURPLE_MAJOR]];
        
        // Setup a new region with that UUID and same identifier as the broadcasting beacon
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:BEACON_PROXIMITY_UUID identifier:@"Estimote Region"];
    }
    return self;
}

- (void)start
{
    [self.locationManager startMonitoringForRegion:self.region];
}

- (void)stop
{
    [self.locationManager stopMonitoringForRegion:self.region];
}

#pragma mark - CLLocationManagerDelegate methods

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.region];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"Region inside:%@ ", region.identifier);
            [self.locationManager startRangingBeaconsInRegion:self.region];
            
            break;
        case CLRegionStateOutside:
            NSLog(@"Region outside:%@ ", region.identifier);
        case CLRegionStateUnknown:
            NSLog(@"Region unknown");
        default:
            // stop ranging beacons, etc
            NSLog(@"Region unknown (default case");
    }
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    // locationManager didDetermineState handles this case
//    [self.locationManager startRangingBeaconsInRegion:self.region];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    // locationManager didDetermineState handles this case
//    [self.locationManager stopRangingBeaconsInRegion:self.region];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
//    NSLog(@"LM didRangeBeacons (found beacon"); // debug
    
    // print out all beacons
    for (CLBeacon *beacon in beacons)
    {
//        NSString *uuid = beacon.proximityUUID.UUIDString; // Not used, just for reference
        NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
        
        // HACK ALERT: We use major + minor as key
        if ([self.registeredBeaconMajor containsObject:major])
        {
            if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
            {
                [self.delegate discoveredBeaconWithMajor:major minor:minor proximity:beacon.proximity];
            }
        }
    }
    
}

@end