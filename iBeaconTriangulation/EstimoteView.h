//
//  EstimoteView.h
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimoteView : UIView // UIImageView

@property(nonatomic, strong) UILabel *coordinateLabel;
@property(nonatomic) int step;
@property(nonatomic) CGPoint lastLocation;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image step:(int)step;
- (void)setCoordinates:(CGPoint)point;

@end
