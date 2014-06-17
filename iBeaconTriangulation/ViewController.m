//
//  ViewController.m
//  iBeaconTriangulation
//
//  Created by Nicolas Flacco on 6/15/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

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
    
    // Create iBeacons
    EstimoteView *blueEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconBlue"] coordinates:CGPointMake(112, 237)];
    EstimoteView *greenEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconGreen"] coordinates:CGPointMake(165, 147)];
    EstimoteView *purpleEstimote = [self createBeaconView:[UIImage imageNamed:@"beaconPurple"] coordinates:CGPointMake(213, 237)];
    
    self.iBeacons = @[blueEstimote, greenEstimote, purpleEstimote];
    for(EstimoteView *estimote in self.iBeacons) {
        estimote.userInteractionEnabled = NO;
        estimote.coordinateLabel.hidden = YES;
        [self.view addSubview:estimote];
    }
    
    self.editMode = NO;
    self.scanMode = NO;
    
    // Make menu button (delta)
    UIImage *menuImage = MENU_IMG_OFF;
    UIButton *menuButton = [self makeMenuButton:menuImage left:NO];
    [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton = menuButton;
    
    // Make scan button (antenna)
    UIImage *scanImage = SCAN_IMG_OFF;
    UIButton *scanButton = [self makeMenuButton:scanImage left:YES];
    [scanButton addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.scanButton = scanButton;
}

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
