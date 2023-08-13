//
//  MapViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//
//  ViewController for the Map View section of the app.
//  This class is responsible to display the user location and the annotation near him.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface MapViewController () <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MapViewController

@synthesize mapView = _mapView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    // Create a location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    // Add annotation to the map
    // TODO: sostituire con la lista delle annotazioni salvate in locale e salvate in un file json
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(45.464664, 9.188540);    // Milan
    annotation.title = @"Milan";
    annotation.subtitle = @"Italy";
    [self.mapView addAnnotation:annotation];
    
}


-(void) locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        self.mapView.showsUserLocation = YES;
    }
    else {
        self.mapView.showsUserLocation = NO;
    }
}


-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(nonnull id<MKAnnotation>)annotation {
    
    // check if the annotation is the user location
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // check if the annotation is a custom annotation
    if([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MKMarkerAnnotationView *pinView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if(!pinView) {
            
            pinView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:annotationIdentifier];
            pinView.canShowCallout = YES;
            
            // Add a button to the annotation callout
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailButton addTarget:self action:@selector(annotationCalloutTapped:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = detailButton;
            
        
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}


- (void) annotationCalloutTapped:(id<MKAnnotation>)annotation {
    // TODO: sostituire il log con l'accesso alle informazioni sul pin corrispondete all'annotation
    
    NSLog(@"Annotation callout tapped");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
