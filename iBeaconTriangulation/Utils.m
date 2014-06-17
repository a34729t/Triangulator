//
//  Utils.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#define estimoteImg         [UIImage imageNamed:@"Estimote"]
#define estimoteLightBlue   [UIColor colorWithRed:161.0/255.0 green:227.0/255.0 blue:255.0/255.0 alpha:1]
#define estimoteLightGreen  [UIColor colorWithRed:188.0/255.0 green:245.0/255.0 blue:200.0/255.0 alpha:1]
#define estimoteDarkPurple  [UIColor colorWithRed:72.0/255.0 green:61.0/255.0 blue:139.0/255.0 alpha:1]


+ (UIImage *)blueEstimote
{
    return [Utils filledImageFrom:estimoteImg withColor:estimoteLightBlue];
}

+ (UIImage *)greenEstimote
{
    return [Utils filledImageFrom:estimoteImg withColor:estimoteLightGreen];
}

+ (UIImage *)purpleEstimote
{
    return [Utils filledImageFrom:estimoteImg withColor:estimoteDarkPurple];
}

// From http://stackoverflow.com/questions/845278/overlaying-a-uiimage-with-a-color?lq=1
+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color
{
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
