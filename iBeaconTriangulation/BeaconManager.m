//
//  BeaconManager.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "BeaconManager.h"

@interface BeaconManager ()

// TODO

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
        // TODO
    }
    return self;
}

// TODO


@end