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
    
    // preleva i luoghi dal database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Errore nel caricamento dei luoghi: %@", error);
    }
    
    // Set the map view delegate
    self.mapView.delegate = self;
    
    // Create a location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    // Add annotation to the map
    // TODO: sostituire con la lista delle annotazioni salvate in locale e salvate in un file json
    for (PlaceMO *place in self.places) {
        // NSLog(@"Place: %@", place.name);
        
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        // layout della annotatio
        
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
            
            // Creazione di una vista personalizzata per il callout
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
        
        // Esegui il segue verso la schermata dei dettagli, passando l'oggetto PlaceMO
        [self performSegueWithIdentifier:@"ShowDetailSegue" sender:selectedPlace];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceDetailsViewController class]]) {
            PlaceDetailsViewController *detailVC = (PlaceDetailsViewController *)segue.destinationViewController;
            
            // Passa il PlaceMO selezionato alla schermata dei dettagli
            detailVC.selectedPlaceMO = sender;
            
        }
    }
}


@end
