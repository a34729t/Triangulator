//
//  ViewController.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

@import CoreLocation;
#import "ViewController.h"
#import "EstimoteView.h"
#import "GridView.h"
#import "Utils.h"

#define NUMBER_COLUMNS      10
#define MENU_IMG_OFF        [Utils filledImageFrom:[UIImage imageNamed:@"menuIcon"] withColor:[UIColor blackColor]]
#define MENU_IMG_ON         [Utils filledImageFrom:[UIImage imageNamed:@"menuIcon"] withColor:[UIColor grayColor]]
#define SCAN_IMG_OFF        [Utils filledImageFrom:[UIImage imageNamed:@"scanIcon"] withColor:[UIColor blackColor]]
#define SCAN_IMG_ON         [Utils filledImageFrom:[UIImage imageNamed:@"scanIcon"] withColor:[UIColor grayColor]]
@interface ViewController ()

@property (nonatomic) BOOL editMode;
@property (nonatomic, strong) GridView *grid;
@property (nonatomic, strong) NSArray *iBeacons;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic) BOOL scanMode;

@property (nonatomic, strong) EstimoteView *blueEstimote;
@property (nonatomic, strong) EstimoteView *greenEstimote;
@property (nonatomic, strong) EstimoteView *purpleEstimote;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Set background image
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_SandyCay"]];
    [self.view addSubview:backgroundView];
    
    // Draw grid
    GridView *grid = [[GridView alloc] initWithFrame:self.view.frame columns:NUMBER_COLUMNS];
    grid.alpha = 0.25;
    [self.view addSubview:grid];
    self.grid = grid;
    
    // Create iBeacons and pretty positions for them
    double width = self.view.frame.size.width;
    double height = self.view.frame.size.height;
    CGPoint point0 = CGPointMake(width/3, height/1.5);
    CGPoint point1 = CGPointMake(width/6, height/8);
    CGPoint point2 = CGPointMake(width/1.5, height/3);

    self.blueEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconBlue"] coordinates:point0];
    self.greenEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconGreen"] coordinates:point1];
    self.purpleEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconPurple"] coordinates:point2];
    
    self.iBeacons = @[self.blueEstimote, self.greenEstimote, self.purpleEstimote];
    for(EstimoteView *estimote in self.iBeacons) {
        estimote.userInteractionEnabled = NO;
        estimote.coordinateLabel.hidden = YES;
        [self.view addSubview:estimote];
    }

    // Add our menu buttons
    self.editMode = NO;
    self.scanMode = NO;

    // Make menu button (delta)
    UIImage *menuImage = MENU_IMG_OFF;
    UIButton *menuButton = [self makeMenuButton:menuImage left:YES];
    [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton = menuButton;
    
    // Make scan button (antenna)
    UIImage *scanImage = SCAN_IMG_OFF;
    UIButton *scanButton = [self makeMenuButton:scanImage left:NO];
    [scanButton addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.scanButton = scanButton;

    // Display marker relative to iBeacons
    CGPoint marker0 = [self blue:CLProximityUnknown green:CLProximityUnknown purple:CLProximityUnknown];
    CGPoint marker1 = [self blue:CLProximityUnknown green:CLProximityUnknown purple:CLProximityUnknown];
    CGPoint marker2 = [self blue:CLProximityFar green:CLProximityUnknown purple:CLProximityUnknown];
    CGPoint marker3 = [self blue:CLProximityImmediate green:CLProximityUnknown purple:CLProximityUnknown];

    CGPoint marker4 = [self blue:CLProximityImmediate green:CLProximityFar purple:CLProximityUnknown];
    CGPoint marker5 = [self blue:CLProximityNear green:CLProximityFar purple:CLProximityNear];

    UIImage *markerImage = [Utils filledImageFrom:[UIImage imageNamed:@"menuIcon"] withColor:[UIColor greenColor]];
    UIImageView *markerView = [[UIImageView alloc] initWithImage:markerImage];

    CGPoint marker = marker5;
    markerView.frame = CGRectMake(marker.x, marker.y, 150/4, 133/4);
    [self.view addSubview:markerView];
}

#pragma mark - Marker Helpers

- (CGPoint) blue:(CLProximity)blue green:(CLProximity)green purple:(CLProximity)purple
{
    // Unknown case - Marker in center of screen (?)
    if (blue == CLProximityUnknown && green == CLProximityUnknown && purple == CLProximityUnknown) {
        return self.view.center;
        // TODO: Make it a question mark
    }

    // 2 Unknown case


    // 1 Unknown case

    // 0 Unknown case
    if (blue != CLProximityUnknown && green != CLProximityUnknown && purple != CLProximityUnknown) {

        NSLog(@"self.blueEstimote.center.x/blue = %f", self.blueEstimote.center.x/blue);
        NSLog(@"self.greenEstimote.center.x/green = %f", self.greenEstimote.center.x/green);
        NSLog(@"self.purpleEstimote.center.x/purple = %f", self.purpleEstimote.center.x/purple);

        GLfloat centerX = (self.blueEstimote.center.x/blue + self.greenEstimote.center.x/green + self.purpleEstimote.center.x/purple) / 3;
        GLfloat centerY = (self.blueEstimote.center.y/blue + self.greenEstimote.center.y/green + self.purpleEstimote.center.y/purple) / 3;

        return CGPointMake(centerX, centerY);
    }


    // TODO: If marker would be offscreen, find the nearest point within 50 px of border?

    return CGPointMake(0, 0);
}

- (int)CLProximity2Int:(CLProximity)proximity
{
    if (proximity == CLProximityUnknown) {
        return -100;
    }
    else if (proximity == CLProximityFar) {
        return 1;
    }
    else if (proximity == CLProximityNear) {
        return 1;
    }
    else if (proximity == CLProximityImmediate) {
        return 1;
    }
    else {
        return -100;
    }
}



#pragma mark - View Helpers

- (EstimoteView *)createBeaconView:(UIImage *)image coordinates:(CGPoint)point
{
    double scaleFactor = 3.0f;
    int step = (int)self.view.frame.size.width / NUMBER_COLUMNS;
    CGRect rect = CGRectMake(point.x, point.y, 200.0f/scaleFactor, 340.0f/scaleFactor);
    EstimoteView *beaconView = [[EstimoteView alloc] initWithFrame:rect
                                                             image:image
                                                              step:step];
    return beaconView;
}

- (UIButton *)makeMenuButton:(UIImage *)image left:(BOOL)left
{
    double menuWidth = 150/4;
    double menuHeight = 133/4;
    double menuPadding = 10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (left) {
        button.frame = CGRectMake( menuPadding , self.view.frame.size.height - menuHeight - menuPadding, menuWidth, menuHeight);
    } else {
        button.frame = CGRectMake(self.view.frame.size.width - menuWidth - menuPadding , self.view.frame.size.height - menuHeight - menuPadding, menuWidth, menuHeight);
    }
    [button setImage:image forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
}

- (void)menuButtonClicked:(id)sender
{
    // Switch edit mode
    self.editMode = !self.editMode;
    
    // Change color of button
    if (self.editMode) {
        [self.menuButton setImage:MENU_IMG_ON forState:UIControlStateNormal];
    } else {
        [self.menuButton setImage:MENU_IMG_OFF forState:UIControlStateNormal];
    }
    
    // Change grid alpha
    if (self.editMode) {
        self.grid.alpha = 0.6;
    } else {
        self.grid.alpha = 0.25;
    }
    
    // Change state of estimotes to draggable or not
    for(EstimoteView *estimote in self.iBeacons) {
        estimote.userInteractionEnabled = !estimote.userInteractionEnabled;
        estimote.coordinateLabel.hidden = !estimote.coordinateLabel.hidden;
    }
}

- (void)scanButtonClicked:(id)sender
{
    self.scanMode = !self.scanMode;
    
    // Change color of button
    if (self.scanMode) {
        [self.scanButton setImage:SCAN_IMG_OFF forState:UIControlStateNormal];
    } else {
        [self.scanButton setImage:SCAN_IMG_ON forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveMarker:(id)sender
{
}

@end
