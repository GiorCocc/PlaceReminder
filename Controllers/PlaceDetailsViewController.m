//
//  TablePinnedPlaceViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//
//  ViewController for displaying the details of a place.
//

#import "PlaceDetailsViewController.h"
#import "CoreDataManager.h"
#import "AddNewPlaceTableViewController.h"
#import "AppDelegate.h"

@interface PlaceDetailsViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *mapCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UISwitch *switchReminder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openInMapBarButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *distanceCell;

@end

@implementation PlaceDetailsViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSLog(@"Showing selected place details: %@", self.selectedPlaceMO);

    self.title = self.selectedPlaceMO.name;
    
    // map
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;
    
    // annotations
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.selectedPlaceMO.latitude, self.selectedPlaceMO.longitude);
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // update UI
    [self updateUIWithData:self.selectedPlaceMO];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self updateMapViewWithPlace:self.selectedPlaceMO];
}

#pragma mark Map

- (void) updateMapViewWithPlace:(PlaceMO *)place {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.distanceCell.detailTextLabel.text = @"Calculating...";
    
    CLLocation *userLocation = [locations lastObject];
    
    float distance = [userLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.selectedPlaceMO.latitude longitude:self.selectedPlaceMO.longitude]];
    
    if (distance > 1000) {
        self.distanceCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f km", distance / 1000];
    } else {
        self.distanceCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m", distance];
    }
}

- (void)updateUIWithData:(PlaceMO *)place {
    self.title = place.name;
    
    self.nameCell.detailTextLabel.text = place.name;
    self.addressCell.detailTextLabel.text = place.address;
    self.switchReminder.on = place.remember;
    self.notesCell.detailTextLabel.text = place.notes;
    
    [self updateMapViewWithPlace:place];
}

- (void) didEditPlace:(PlaceMO *)editedPlace {
    // NSLog(@"Edited place: %@", editedPlace);
    self.selectedPlaceMO = editedPlace;
    [self updateUIWithData:editedPlace];
    
    // remove old annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self updateMapViewWithPlace:editedPlace];
}

- (void) didAddNewPlace:(nonnull PlaceMO *)place { }

# pragma mark AppBar actions

- (IBAction)removePlaceButtonPressed:(id)sender {
    // NSLog(@"Remove place button pressed");
    
    // alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove"
                                                                   message:@"Are you sure you want to remove this place?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Remove"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
        // remove place from database
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
        [context deleteObject:self.selectedPlaceMO];
        
        NSError *error = nil;
        [context save:&error];
        
        if (error) {
            NSLog(@"Error removing place: %@", error);
        }
        
        [self.delegate didRemovePlace:self.selectedPlaceMO];
        
        // remove geofence
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate updateGeofenceSettings];
        
		// go back to previous view (home screen)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *) mapURLForPlace:(PlaceMO *)place {
    NSString *address = self.selectedPlaceMO.address;
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    address = [address stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address];
    
    return urlString;
}

- (IBAction)openInMap:(id)sender {
    // NSLog(@"Open in map button pressed");
    
    // open the place in Apple Maps
    NSString *urlString = [self mapURLForPlace:self.selectedPlaceMO];
    NSURL *url = [NSURL URLWithString:urlString];
	
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (IBAction)sharePlaceInfo:(id)sender {
    NSString *textToShare = [NSString stringWithFormat:@"I want to share with you this place: %@ ~ %@\n\nOpen directly in map:\n%@",
                             self.selectedPlaceMO.name,
                             self.selectedPlaceMO.address,
                             [self mapURLForPlace:self.selectedPlaceMO]];
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                                                             applicationActivities:nil];
    
    [self presentViewController:activity animated:YES completion:nil];
}

#pragma mark Table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {   // map
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.selectedPlaceMO.name;
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.selectedPlaceMO.address;
            
        } else if (indexPath.row == 2) { // distance from user
            CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                                                  longitude:self.mapView.userLocation.coordinate.longitude];
            CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:self.selectedPlaceMO.latitude
                                                                   longitude:self.selectedPlaceMO.longitude];
            CLLocationDistance distance = [userLocation distanceFromLocation:placeLocation];
            
            if (distance > 1000) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f km", distance / 1000];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m", distance];
            }
        }
        
        return cell;
    } else if (indexPath.section == 2) {    // reminder
		self.selectedPlaceMO.remember ? [self.switchReminder setOn:YES] : [self.switchReminder setOn:NO];
        
        return cell;
    } else if (indexPath.section == 3) {    // notes
        if (self.selectedPlaceMO.notes == nil || [self.selectedPlaceMO.notes isEqualToString:@""]) {
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = @"No notes";
        } else {
            cell.detailTextLabel.text = self.selectedPlaceMO.notes;
        }
        
        return cell;
    }
    
    return nil;
}

- (IBAction)updatePlaceReminder:(id)sender {
    // NSLog(@"Update place reminder");
    
    self.selectedPlaceMO.remember = self.switchReminder.isOn;
    
    // save the context
    NSError *error = nil;
    [[CoreDataManager sharedManager].managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error saving context: %@", error);
    }
    
	// update geofence settings
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateGeofenceSettings];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        NSString *insertTime = [NSDateFormatter localizedStringFromDate:self.selectedPlaceMO.insert_time
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        
        NSString *lastUpdateAt = [NSString stringWithFormat:@"Last update at: %@", insertTime];
        
        label.text = lastUpdateAt;
        
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        label.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 15);
        
        return label;
    }
    
    return nil;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1){	// address row
        // copy address to clipboard
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.selectedPlaceMO.address;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    if (section == 0)       // map
        return 1;
    else if (section == 1)  // informations
        return 3;           // name, address, insert time, distance
    else if (section == 2)  // remider
        return 1;
    else if (section == 3)  // notes
        return 1;
    
    return 0;
}

#pragma mark - Navigation

- (IBAction)editPlace:(id)sender {
    // NSLog(@"Edit place button pressed");
    
    PlaceMO *place = self.selectedPlaceMO;
    
    [self performSegueWithIdentifier:@"EditSelectedPlaceSegue" sender:place];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"EditSelectedPlaceSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[AddNewPlaceTableViewController class]]) {
            AddNewPlaceTableViewController *detailVC = (AddNewPlaceTableViewController *)segue.destinationViewController;
            
            // pass the place to edit to the detail view controller
            detailVC.placeToEdit = sender;
        }
    }
}


@end
