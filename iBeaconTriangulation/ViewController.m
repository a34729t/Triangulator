//
//  ViewController.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

@import CoreLocation;
#import "BeaconManager.h"
#import "EstimoteView.h"
#import "GridView.h"
#import "Utils.h"
#import "ViewController.h"

#define NUMBER_COLUMNS      10
#define MENU_IMG_OFF        [Utils filledImageFrom:[UIImage imageNamed:@"menuIcon"] withColor:[UIColor blackColor]]
#define MENU_IMG_ON         [Utils filledImageFrom:[UIImage imageNamed:@"menuIcon"] withColor:[UIColor grayColor]]
#define SCAN_IMG_OFF        [Utils filledImageFrom:[UIImage imageNamed:@"scanIcon"] withColor:[UIColor blackColor]]
#define SCAN_IMG_ON         [Utils filledImageFrom:[UIImage imageNamed:@"scanIcon"] withColor:[UIColor grayColor]]

@interface ViewController () <BeaconManagerDelegate>

// Class properties
@property (nonatomic) BOOL editMode; // Change locations of iBeacons
@property (nonatomic) BOOL scanMode; // Start scanning
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) BeaconManager *beaconManager;

// iBeacons
@property (nonatomic, strong) EstimoteView *blueEstimote;
@property (nonatomic, strong) EstimoteView *greenEstimote;
@property (nonatomic, strong) EstimoteView *purpleEstimote;
@property (nonatomic, strong) NSArray *iBeacons;

// UI
@property (nonatomic, strong) GridView *grid;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIImageView *markerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Setup BeaconManager
    self.beaconManager = [BeaconManager sharedInstance];
    
    // Set background image
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sandycay"]];
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

    // TODO: Set the major and minor for the beacons with a config file!
    self.blueEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconBlue"]
                                   coordinates:point0
                                         major:BEACON_BLUE_MAJOR
                                         minor:BEACON_BLUE_MINOR];
    self.greenEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconGreen"]
                                    coordinates:point1
                                          major:BEACON_GREEN_MAJOR
                                          minor:BEACON_GREEN_MINOR];
    self.purpleEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconPurple"]
                                     coordinates:point2
                                           major:BEACON_PURPLE_MAJOR
                                           minor:BEACON_PURPLE_MINOR];
    
    self.iBeacons = @[self.blueEstimote, self.greenEstimote, self.purpleEstimote];
    for(EstimoteView *estimote in self.iBeacons) {
        // NOTE: These settings don't seem to work when set in view initializer
        estimote.userInteractionEnabled = NO;
        estimote.coordinateLabel.hidden = YES;
        [self.view addSubview:estimote];
    }

    // Initialize settings
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

    // Make a location marker
    UIImage *markerImage = [Utils filledImageFrom:[UIImage imageNamed:@"locationIcon"] withColor:[UIColor blackColor]];
    self.markerView = [[UIImageView alloc] initWithImage:markerImage];
    CGPoint marker = [self updateLocationMarker];
    self.markerView.frame = CGRectMake(marker.x, marker.y - (133/6), 150/3, 133/3);
    [self.view addSubview:self.markerView];
}

#pragma mark - BeaconManager Delegate Methods

-(void)discoveredBeaconWithMajor:(NSString *)major minor:(NSString *)minor proximity:(CLProximity)proximity
{
//    // debug
//    NSString *distance;
//    if(proximity == CLProximityUnknown) {
//        distance = @"Unknown Proximity";
//    } else if (proximity == CLProximityImmediate) {
//        distance = @"Immediate";
//    } else if (proximity == CLProximityNear) {
//        distance = @"Near";
//    } else if (proximity == CLProximityFar) {
//        distance = @"Far";
//    } else {
//        return;
//    }
//    NSLog(@"VC major:%@ minor:%@ distance:%@", major, minor, distance);
    
    for(EstimoteView *estimote in self.iBeacons) {
        if ([estimote.major isEqual:major] && [estimote.minor isEqual:minor]) {
            estimote.proximity = proximity;
        }
    }

    // Update markerView
    CGPoint marker = [self updateLocationMarker];
    self.markerView.frame = CGRectMake(marker.x, marker.y - (133/6), 150/3, 133/3);
}

#pragma mark - Marker Helpers

- (CGPoint)updateLocationMarker
{
    // Unknown case - Marker in center of screen (?)
    int num=0;
    for(EstimoteView *estimote in self.iBeacons) {
        if (estimote.proximity == CLProximityUnknown) {
            num++;
        }
    }
    if (num == [self.iBeacons count]) {
        // TODO: Make it a question mark
        return self.view.center;
    }
    
    // Possible Class Exercise:
    // 1 ... N-1 unknown case?
    // If marker would be offscreen, find the nearest point within 50 px of border?
    
    // All known case:
    // We want to weight nearer iBeacons more than further ones. We simply create an array of
    // x-coordinates, and the nearer an iBeacon is, the more times we add it to the array, so
    // that the average value is influenced more!
    
    // HACK ALERT: I use two arrays as hack cause otherwise I'd do NSValue (for lack of tuple) cause arrays cannot take primitives
    int xTotal = 0;
    int yTotal = 0;
    int xCount = 0;
    int yCount = 0;
    for(EstimoteView *estimote in self.iBeacons) {
        for(int i = 0; i <= [self CLProximity2Int:estimote.proximity]; i++) {
            xTotal += estimote.center.x;
            yTotal += estimote.center.y;
            xCount++;
            yCount++;
        }
    }
    
//    NSLog(@"Updated (%d,%d)", xTotal/xCount, yTotal/yCount); // debug
    return CGPointMake(xTotal/xCount, yTotal/yCount);
}

- (int)CLProximity2Int:(CLProximity)proximity
{
    if (proximity == CLProximityUnknown) {
        return 0;
    }
    else if (proximity == CLProximityFar) {
        return 1;
    }
    else if (proximity == CLProximityNear) {
        return 5;
    }
    else if (proximity == CLProximityImmediate) {
        return 100;
    }
    else {
        return 0;
    }
}

#pragma mark - View Helpers

- (EstimoteView *)createBeaconView:(UIImage *)image coordinates:(CGPoint)point major:(NSString *)major minor:(NSString *)minor
{
    double scaleFactor = 3.0f;
    int step = (int)self.view.frame.size.width / NUMBER_COLUMNS;
    CGRect rect = CGRectMake(point.x, point.y, 200.0f/scaleFactor, 340.0f/scaleFactor);
    EstimoteView *beaconView = [[EstimoteView alloc] initWithFrame:rect
                                                             image:image
                                                              step:step
                                                             major:major
                                                             minor:minor
                                ];
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
    NSLog(@"scanButtonClicked");
    
    self.scanMode = !self.scanMode;
    
    // Change color of button
    if (self.scanMode) {
        [self.scanButton setImage:SCAN_IMG_OFF forState:UIControlStateNormal];
        [self.beaconManager stop];
        self.beaconManager.delegate = nil;
    } else {
        [self.scanButton setImage:SCAN_IMG_ON forState:UIControlStateNormal];
        [self.beaconManager start];
        self.beaconManager.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
