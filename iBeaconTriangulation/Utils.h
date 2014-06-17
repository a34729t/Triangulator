//
//  Utils.h
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (UIImage *)blueEstimote;
+ (UIImage *)greenEstimote;
+ (UIImage *)purpleEstimote;
+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;

@end
