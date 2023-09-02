//
//  HomePageViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 17/08/23.
//
//  This ViewController is in charge of showing a map containing the user's location and favorite places near him
//  Below the map there is a TableView with dynamic cells showing, in a subtitle structure, the name of the place and its address
//  Clicking on a cell opens a new screen showing the details of the selected place
//  The places are present in the database and must be retrieved from there
//  At the top right there is a button that allows you to add a new place and the button to go and see the map in full screen
//

#import "HomePageViewController.h"
#import "CoreDataManager.h"
#import "PlaceMO+CoreDataProperties.h"
#import "AddNewPlaceTableViewController.h"
#import "PlaceDetailsViewController.h"
#import "AppDelegate.h"


@interface HomePageViewController () <AddNewPlaceDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *places;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) PlaceMO *selectedPlaceMO;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end



@implementation HomePageViewController

@synthesize mapView = _mapView;


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Errorloading places: %@", error);
    }
    
    // map
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    // annotations
    CLLocationCoordinate2D placeCoordinate;
    CLCircularRegion *region;
    
    for (PlaceMO *place in self.places) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        [self.mapView addAnnotation:annotation];
        
        if (place.remember){
            placeCoordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
            region = [[CLCircularRegion alloc] initWithCenter:placeCoordinate radius:500 identifier:place.name];
            [region setNotifyOnEntry:YES];
            [region setNotifyOnExit:NO];
        }
    }
    
    // geofencing
    [self.locationManager startMonitoringForRegion:region];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// get data from database
	NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
	NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
	NSError *error = nil;
	self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
	if (error) {
		NSLog(@"Errorloading places: %@", error);
	}
	
	[self.tableView reloadData];
	[self updateMapView];
}

- (void) updateMapView {
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	for (PlaceMO *place in self.places) {
		MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
		annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
		[self.mapView addAnnotation:annotation];
	}
}

- (void) didAddNewPlace: (PlaceMO *) newPlace {
	
	// NSLog(@"didAddNewPlace chiamato dal delegate");
	[self.places addObject:newPlace];
	[self.tableView reloadData];
	
	// annotations
	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	annotation.coordinate = CLLocationCoordinate2DMake(newPlace.latitude, newPlace.longitude);
	[self.mapView addAnnotation:annotation];
	
	// update geofence settings
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate updateGeofenceSettings];
}

- (void) didEditPlace:(nonnull PlaceMO *)place {}


- (void) didRemovePlace: (PlaceMO *) place {
	// NSLog(@"didRemovePlace chiamato dal delegate");
	[self.places removeObject:place];
	[self.tableView reloadData];
	
	// remove annotation
	for (MKPointAnnotation *annotation in self.mapView.annotations) {
		if (annotation.coordinate.latitude == place.latitude && annotation.coordinate.longitude == place.longitude) {
			[self.mapView removeAnnotation:annotation];
		}
	}
	
	// update geofence settings
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate updateGeofenceSettings];
}


#pragma mark Location

-(void) locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        self.mapView.showsUserLocation = YES;
        
        // Zoom the map to the user's location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(manager.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }
    else {
        self.mapView.showsUserLocation = NO;
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *userLocation = [locations lastObject];
    
    // Zoom the map to the user's location
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    return self.places.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PlaceMO *place = self.places[indexPath.row];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.address;
    
    return cell;
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // alert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Remove"
                                                                                 message:@"Are you sure you want to remove this place?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // Aggiungi l'azione per la cancellazione
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
            // remove from database
            PlaceMO *place = self.places[indexPath.row];
            NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
            [context deleteObject:place];
            
            NSError *error = nil;
            [context save:&error];
            
            if (error) {
                NSLog(@"Errorsaving context: %@", error);
            } else {
                // remove from array
                [self.places removeObjectAtIndex:indexPath.row];
                
                // remove from table
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self updateMapView];
                
                // remove geofence
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate updateGeofenceSettings];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - Navigation

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PlaceMO *selectedPlace = self.places[indexPath.row];
    self.selectedPlaceMO = selectedPlace;

    [self performSegueWithIdentifier:@"ShowDetailsSegue" sender:selectedPlace];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetailsSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceDetailsViewController class]]) {
            PlaceDetailsViewController *detailVC = (PlaceDetailsViewController *)segue.destinationViewController;
            
            // pass the selected place to the detail view controller
            detailVC.selectedPlaceMO = sender;
            
        }
    }
}

@end
