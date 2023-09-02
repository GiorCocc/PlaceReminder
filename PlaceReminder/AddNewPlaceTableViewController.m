//
//  AddNewPlaceTableViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 15/08/23.
//
//  In this screen, a new item is added to the list of favorite places.
//  The screen consists of a TableView that includes 4 sections and each cell is a static element
//  The sections and the information they contain are:
//      - Map (map)
//      - Informations:
//          - Place name (text field)
//          - Place address (text field)
//      - Reminder (switch)
//      - Notes (text field)
//

#import "AddNewPlaceTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "CoreDataManager.h"
#import "PlaceMO+CoreDataClass.h"
#import "AppDelegate.h"


@interface AddNewPlaceTableViewController ()

@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *nameTableViewCell;
@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *addressTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *reminderTabelViewCell;
@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *notesTabelViewCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userLocationButton;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSString *placeNotes;
@property (nonatomic, assign) BOOL placeRemember;
@property (nonatomic, strong) NSDate *placeInsertTime;
@property (nonatomic) double placeLatitude;
@property (nonatomic) double placeLongitude;

@end



@implementation AddNewPlaceTableViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // registra nib
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ReminderCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NotesCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MapCell"];

    // set the title of the navigation bar
    if (self.placeToEdit){
        self.title = @"Edit: ";
        self.navigationItem.title = [self.navigationItem.title stringByAppendingString:self.placeToEdit.name];
    } else {
        self.navigationItem.title = @"Add new place";
    }
    
    // set the left bar button item
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(doneButtonTapped)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // location
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *userLocation = [locations lastObject];
    
    // place the center of the map on the user's location
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
    
    // if the place to edit is not null, place the center of the map on the place to edit
    if (self.placeToEdit) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.placeToEdit.latitude, self.placeToEdit.longitude)];
    }
}

#pragma mark Buttons

- (void)switchChanged:(UISwitch *)sender {
    // NSLog(@"Switch changed %d", sender.isOn);
    
    self.placeRemember = sender.isOn;
}

- (void) errorAlertWithMessage:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doneButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                   message:@"Do you want to save the place?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        // get the data from the text fields
        TextFieldTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        TextFieldTableViewCell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        TextFieldTableViewCell *notesCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        NSString *placeName = nameCell.textField.text;
        NSString *placeAddress = addressCell.textField.text;
        NSString *notes = notesCell.textField.text;
        
        // database validation: check if the name and address fields are empty
        if ([placeName isEqualToString:@""] || [placeAddress isEqualToString:@""]) {
            [self errorAlertWithMessage:@"Name and address fields cannot be empty"];
            
            return;
        }
        
        self.placeName = placeName;
        self.placeAddress = placeAddress;
        self.placeNotes = notes;
        
        // insert tday date into the database
        NSDate *currentDate = [NSDate date];
        self.placeInsertTime = currentDate;
        
        // location: get the coordinates from the address
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:placeAddress
                     completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Geocode error: %@", error.localizedDescription);
                
                [self errorAlertWithMessage:@"Coordinates not found for the specified address. Check if the address is correct and try again."];
                
                return;
            }
            
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                CLLocation *location = placemark.location;
                
                self.placeLatitude = location.coordinate.latitude;
                self.placeLongitude = location.coordinate.longitude;
                
                // location: reverse geocode the coordinates to get the full address
                location = [[CLLocation alloc] initWithLatitude:self.placeLatitude longitude:self.placeLongitude];
                [geocoder reverseGeocodeLocation:location
                               completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Geocode error: %@", error.localizedDescription);
                        
                        [self errorAlertWithMessage:@"Address not found for the specified coordinates"];
                        
                        return;
                    }
                    
                    if (placemarks && placemarks.count > 0) {
                        CLPlacemark *placemark = placemarks.firstObject;
                        NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@, %@, %@",
                                             placemark.thoroughfare,
                                             placemark.subThoroughfare ? placemark.subThoroughfare : @"",
                                             placemark.postalCode,
                                             placemark.locality,
                                             placemark.administrativeArea,
                                             placemark.country];
                        
                        self.placeAddress = address;
                    }
                    
                    // save the place in the database
                    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
                    
                    if (context) {
                        if (self.placeToEdit) {
                            
                            // update the place
                            self.placeToEdit.name = self.placeName;
                            self.placeToEdit.address = self.placeAddress;
                            self.placeToEdit.notes = self.placeNotes;
                            self.placeToEdit.remember = self.placeRemember;
                            self.placeToEdit.insert_time = self.placeInsertTime;
                            self.placeToEdit.latitude = self.placeLatitude;
                            self.placeToEdit.longitude = self.placeLongitude;
                            
                            
                            NSLog(@"Place updated: name: %@, address: %@, notes: %@, remember: %d, insert_time: %@, latitude: %f, longitude: %f",
                                  self.placeToEdit.name,
                                  self.placeToEdit.address,
                                  self.placeToEdit.notes,
                                  self.placeToEdit.remember,
                                  self.placeToEdit.insert_time,
                                  self.placeToEdit.latitude,
                                  self.placeToEdit.longitude);
                            
                            
                            NSError *error = nil;
                            if (![context save:&error]) {
                                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                            } else {
                                NSLog(@"Data saved");
                                
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                [appDelegate updateGeofenceSettings];
                                
                                // notify the delegate that the place has been edited
                                [self.delegate didEditPlace:self.placeToEdit];
                                
                                // go to the home page
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                            return;
                        
                        } else {
                            // add new place
                            PlaceMO *newPlace = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
                            
                            newPlace.name = self.placeName;
                            newPlace.address = self.placeAddress;
                            newPlace.notes = self.placeNotes;
                            newPlace.remember = self.placeRemember;
                            newPlace.insert_time = self.placeInsertTime;
                            newPlace.latitude = self.placeLatitude;
                            newPlace.longitude = self.placeLongitude;
                            
                            NSLog(@"Place added: name: %@, address: %@, notes: %@, remember: %d, insert_time: %@, latitude: %f, longitude: %f",
                                  newPlace.name,
                                  newPlace.address,
                                  newPlace.notes,
                                  newPlace.remember,
                                  newPlace.insert_time,
                                  newPlace.latitude,
                                  newPlace.longitude);
                            
                            // database save
                            NSError *error = nil;
                            if (![context save:&error]) {
                                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                            
                            } else {
                                NSLog(@"Data saved");
                                
                                // create a geofence for the new place
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                [appDelegate updateGeofenceSettings];
                                
                                // notify the delegate that a new place has been added
                                [self.delegate didAddNewPlace:newPlace];
                                
                                // pop the view controller
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    } else {
                        NSLog(@"Error getting context");
                    }
                    
                }];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.tag == 0)                 // name
        self.placeName = textField.text;
    else if (textField.tag == 1)            // address
        self.placeAddress = textField.text;
    else if (textField.tag == 2)            // notes
        self.placeNotes = textField.text;
    
    return YES;
}

- (IBAction)fillAddressTextFieldWithUserPosition:(id)sender {
    // get the user coordinates
    CLLocation *userLocation = self.mapView.userLocation.location;
    
    // reverse geocode the user location
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Geocode error: %@", error.localizedDescription);
            
            [self errorAlertWithMessage:@"Address not found for the specified coordinates"];
                           
            return;
        }
                       
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@, %@, %@",
                                 placemark.thoroughfare,
                                 placemark.subThoroughfare ? placemark.subThoroughfare : @"",
                                 placemark.postalCode,
                                 placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
                           
            // fill the address text field
            TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            cell.textField.text = address;
        }
                       
    }];
	
	// center the map on the user location
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100);
	[self.mapView setRegion:region animated:YES];
}

# pragma mark Table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {   // map
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        // if the user need to edit a place, display the place annotation on the map
        if (self.placeToEdit) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(self.placeToEdit.latitude, self.placeToEdit.longitude);
            [self.mapView addAnnotation:annotation];
            
            // center the map on the annotation
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 100, 100);
            [self.mapView setRegion:region animated:YES];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {  // informations
        if (indexPath.row == 0) {       // place name
            
            static NSString *NameCellIdentifier = @"TextFieldTableViewCell";
            TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NameCellIdentifier
                                                                                                     forIndexPath:indexPath];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NameCellIdentifier
                                                             owner:self
                                                           options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell configureWithTitle:@"Name" placeholder:@"Place name"];
            
            // fill the text field with the place name if the user is editing a place
            if (self.placeToEdit) {
                cell.textField.text = self.placeToEdit.name;
            }
            
            cell.textField.tag = 0;
           
            return cell;
            
        } else if (indexPath.row == 1) {    // place address
            
            static NSString *AddressCellIdentifier = @"TextFieldTableViewCell";
            TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier
                                                                                                     forIndexPath:indexPath];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:AddressCellIdentifier
                                                             owner:self
                                                           options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell configureWithTitle:@"Address" placeholder:@"Place address"];
            cell.textField.textContentType = UITextContentTypeAddressCityAndState;
            
            // fill the text field with the place address if the user is editing a place
            if (self.placeToEdit) {
                cell.textField.text = self.placeToEdit.address;
            }
            
            cell.textField.tag = 1;
            
            return cell;
        }
        
    } else if (indexPath.section == 2) {    // reminder
        
        static NSString *ReminderCellIdentifier = @"ReminderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReminderCellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:ReminderCellIdentifier];
        }
        
        cell.textLabel.text = @"Reminder";
		cell.textLabel.textAlignment = NSTextAlignmentNatural;
		
		
		
		
		
		
        
        // switch
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        
        // if the user is editing a place, set the switch to the place remember value
        if (self.placeToEdit) {
            self.placeRemember = self.placeToEdit.remember;
        }
        
        [switchView setOn:self.placeRemember animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        return cell;
        
    } else if (indexPath.section == 3) {    // notes
        
        static NSString *NotesCellIdentifier = @"TextFieldTableViewCell";
        TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier
                                                                                             forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NotesCellIdentifier
                                                         owner:self
                                                       options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell configureWithTitle:@"Notes" placeholder:@"Place notes"];
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
        // fill the text field with the place notes if the user is editing a place and the place has notes
        if (self.placeToEdit && self.placeToEdit.notes) {
            cell.textField.text = self.placeToEdit.notes;
        }
        
        cell.textField.tag = 2;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {   // map
        return 250;
    }
    
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows in each section
    if (section == 0)       // map
        return 1;
    else if (section == 1)  // informations
        return 2;           // name, address
    else if (section == 2)  // reminder
        return 1;
    else if (section == 3)  // notes
        return 1;
    else return 0;          // error
}


@end
