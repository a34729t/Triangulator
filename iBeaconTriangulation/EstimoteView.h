//
//  EstimoteView.h
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

@import CoreLocation;
#import <UIKit/UIKit.h>

@interface EstimoteView : UIView // UIImageView

@property(nonatomic, strong) UILabel *coordinateLabel;
@property(nonatomic) int step;
@property(nonatomic) CGPoint lastLocation;
@property(nonatomic, readonly) CGPoint center;
@property(nonatomic) CLProximity proximity;
@property(nonatomic) NSString *major;
@property(nonatomic) NSString *minor;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image step:(int)step major:(NSString *)major minor:(NSString *)minor;
- (void)setCoordinates:(CGPoint)point;

@end
