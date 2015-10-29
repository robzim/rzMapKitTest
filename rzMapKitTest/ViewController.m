//
//  ViewController.m
//  rzMapKitTest
//
//  Created by Robert Zimmelman on 10/27/15.
//  Copyright © 2015 Robert Zimmelman. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>





@interface ViewController ()
@property CLGeocoder *myGeocoder;
@property CLLocationManager *myLocationManager;
@property MKMapCamera *myCamera;
@property (weak, nonatomic) IBOutlet UILabel *myDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLongitudeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
- (IBAction)myQuit:(id)sender;
- (IBAction)myZoomOut:(id)sender;


@end

@implementation ViewController

@synthesize myMapView;
@synthesize myGeocoder;
@synthesize myLocationManager;
@synthesize myCamera;
@synthesize myDistanceLabel;
@synthesize myLatitudeLabel;
@synthesize myLongitudeLabel;

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Locaion Manager Did Fail with Error %@",error);
    //    exit(1);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    myLocationManager = [[CLLocationManager alloc] init];
    myGeocoder = [[CLGeocoder alloc]init];
    [myLocationManager setDelegate:self];
    //    [myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [myLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [myLocationManager requestWhenInUseAuthorization];
    [myLocationManager startUpdatingLocation];
    
    myCamera = [MKMapCamera cameraLookingAtCenterCoordinate:[myLocationManager.location coordinate] fromDistance:10000 pitch:0 heading:myLocationManager.headingOrientation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Authorization Status %d",status);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"Location = %@",[locations lastObject] );
    [myCamera setCenterCoordinate:myLocationManager.location.coordinate];
    [myMapView setCenterCoordinate:myLocationManager.location.coordinate];
    [self myDistanceToHome];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    (void) [myMapView initWithFrame:myMapView.frame];
    [myMapView setCenter:CGPointMake(myMapView.userLocation.coordinate.latitude, myMapView.userLocation.coordinate.longitude)];
    [myMapView setShowsCompass:YES];
    [myMapView setShowsUserLocation:YES];
    [myMapView setShowsScale:YES];
    [myMapView setShowsCompass:YES];
    [myMapView setShowsUserLocation:YES];
    [myMapView setShowsTraffic:YES];
    
    //
    //
    //  rz
    //
    //  myPA and myPinView are not being displayed
    //
    //
    //    MKPointAnnotation *myPA = [[MKPointAnnotation alloc] init];
    //    [myPA setTitle:@"Test Title"];
    //    [myPA setSubtitle:@"Test Subtitle"];
    //    [myPA setCoordinate:CLLocationCoordinate2DMake(40.84, -73.70)];
    //    MKPinAnnotationView *myPinView = [[MKPinAnnotationView alloc] initWithAnnotation:myPA reuseIdentifier:@"Pin"];
    //    [myPinView setAnimatesDrop:YES];
    //    [myPinView setAnnotation:myPA];
    //    [myPinView setFrame:myMapView.frame];
    //    [myMapView addSubview:myPinView];
    //
    //
    //
    //  rz
    //  myPointAnnotation is being displayed
    //
    //
    MKPointAnnotation *myPointAnnotation = [[MKPointAnnotation alloc] init];
    [myPointAnnotation setCoordinate:CLLocationCoordinate2DMake(40.849940, -73.695694)];
    [myPointAnnotation setTitle:@"This is my House"];
    [myPointAnnotation setSubtitle:@"This is what I think would be a longer subtitle with my house as the location"];
    [myMapView addAnnotation:myPointAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myQuit:(id)sender {
    exit(0);
}

- (IBAction)myZoomOut:(id)sender {
    [myMapView.camera setAltitude:100000];
}

- (IBAction)myZoomIn:(id)sender {
    [myMapView.camera setAltitude:1000];
}


- (void)myDistanceToHome {
    CLLocation *myHomeLocation = [[CLLocation alloc] initWithLatitude:40.849940 longitude:-73.695694];
    CLLocation *myCurrentLocation = myLocationManager.location;
    CLLocationDistance  myDistance = [myCurrentLocation distanceFromLocation:myHomeLocation];
    // rz divide by 1000 to get kilometers
    myDistance = myDistance / 1000;
    NSNumber *myNumber = [[NSNumber alloc] initWithFloat:myDistance];
    [myDistanceLabel setText: [NSString stringWithFormat:@"Home is %d km away",[myNumber intValue] ]];
    [myLatitudeLabel setText: [NSString stringWithFormat:@"Current Latitude = %f",myCurrentLocation.coordinate.latitude]];
    [myLongitudeLabel setText: [NSString stringWithFormat:@"Current Longitude = %f",myCurrentLocation.coordinate.longitude]];
}


@end
