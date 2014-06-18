//
//  EstimoteView.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "EstimoteView.h"
#import "Utils.h"

@implementation EstimoteView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image step:(int)step major:(NSString *)major minor:(NSString *)minor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.major = major;
        self.minor = minor;
        self.step = step;
        self.proximity = CLProximityUnknown;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
        self.gestureRecognizers = @[panRecognizer];

        // Estimote image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        // Label for coordinates
        self.coordinateLabel = [[UILabel alloc] initWithFrame:self.frame];
        [self setCoordinates:self.center];
        self.coordinateLabel.textAlignment = NSTextAlignmentCenter;
        self.coordinateLabel.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        [self addSubview:self.coordinateLabel];
    }
    return self;
}

- (void)setCoordinates:(CGPoint)point
{
    self.coordinateLabel.text = [NSString stringWithFormat:@"(%d,%d)", (int)point.x/self.step, (int)point.y/self.step];
}

#pragma mark - Detect gestures

- (void) detectPan:(UIPanGestureRecognizer *) uiPanGestureRecognizer
{
    // Remember the original position
    if(uiPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.lastLocation = self.center;
    }
    
    // Handle panning and end (snap to grid)
    if(uiPanGestureRecognizer.state != UIGestureRecognizerStateEnded) {
        // Keep on panning
        CGPoint translation = [uiPanGestureRecognizer translationInView:self.superview];
        self.center = CGPointMake(self.lastLocation.x + translation.x,
                                  self.lastLocation.y + translation.y);
        
        [self setCoordinates:self.center];
    } else {
        // Snap to grid
        CGPoint newcenter = self.center;
        newcenter.x = self.step * floor((newcenter.x / self.step) + 0.5);
        newcenter.y = self.step * floor((newcenter.y / self.step) + 0.5);
        
        [UIView animateWithDuration:0.1f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.center = newcenter;
                         }
                         completion:nil];
        
        self.center = newcenter;
        [self setCoordinates:self.center];
        
        NSLog(@"endPan (%f,%f)", newcenter.x, newcenter.y);
    }
}

@end
