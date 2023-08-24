//
//  MapViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//
//  ViewController for the Map View section of the app.
//  This class is responsible to display the user location and the annotation near him.

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreDataManager.h"
#import <MapKit/MapKit.h>
#import "PlaceMO+CoreDataProperties.h"
#import "PlaceDetailsViewController.h"
#import "MapAnnotation.h"


@interface MapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *places;

@end



@implementation MapViewController

@synthesize mapView = _mapView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Error loading places: %@", error);
    }
    
    // Set the map view delegate
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    // Create a location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    // Add annotation to the map
    for (PlaceMO *place in self.places) {
        // NSLog(@"Place: %@", place.name);
        
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        annotation.place = place;
        annotation.title = place.name;
        annotation.subtitle = place.address;
        
        [self.mapView addAnnotation:annotation];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // get the places from the database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Error loading places: %@", error);
    }
    
    // update the annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (PlaceMO *place in self.places) {
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        annotation.place = place;
        annotation.title = place.name;
        annotation.subtitle = place.address;
        
        [self.mapView addAnnotation:annotation];
    }
    
}

#pragma mark Location

-(void) locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        self.mapView.showsUserLocation = YES;
        
        // Zoom the map to the user location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    
    }
    else {
        self.mapView.showsUserLocation = NO;
    }
}

#pragma mark Map

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MKMarkerAnnotationView *pinView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (!pinView) {
            pinView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            pinView.canShowCallout = YES;
            
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = detailButton;
            
            // Custom callout
            UIView *calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
            calloutView.backgroundColor = [UIColor whiteColor];
            
            pinView.detailCalloutAccessoryView = calloutView;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[MapAnnotation class]]) {
        MapAnnotation *customAnnotation = (MapAnnotation *)view.annotation;
        PlaceMO *selectedPlace = customAnnotation.place;
        
        // queue to detail view
        [self performSegueWithIdentifier:@"ShowDetailSegue" sender:selectedPlace];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *userLocation = [locations lastObject];
    
    // Zoom the map to the user location
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceDetailsViewController class]]) {
            PlaceDetailsViewController *detailVC = (PlaceDetailsViewController *)segue.destinationViewController;
            
            // send the selected place to the detail view
            detailVC.selectedPlaceMO = sender;
            
        }
    }
}


@end
