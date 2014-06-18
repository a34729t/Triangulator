//
//  Config.h
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#ifndef iBeaconTriangulation_Config_h
#define iBeaconTriangulation_Config_h

// Local notifications for our app
#define NOTIF_KEY               @"WILLIAM_GIBSON_IS_AWESOME"

// Background restore key
#define CM_RESTORE_KEY                  @"CentralManagerRestore"

// General search criteria for beacons that are broadcasting
#define BEACON_SERVICE_NAME     @"estimote"
#define BEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

// Beacons are hardcoded into our app so we can easily filter for them in a noisy environment
#define BEACON_PURPLE_MAJOR     @"60463"
#define BEACON_PURPLE_MINOR     @"56367"
#define BEACON_GREEN_MAJOR      @"544"
#define BEACON_GREEN_MINOR      @"50962"
#define BEACON_BLUE_MAJOR       @"23680"
#define BEACON_BLUE_MINOR       @"7349"

#endif
