//
//  AddNewPlaceTableViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 15/08/23.
//
//  In questa schermata viene aggiunto un nuovo elemento alla lista dei luoghi preferiti.
//  La schermata è composta da una TableView che comprende 1 sezioni e ogni cella è un elemento statico
//  Le sezioni e le informazioni in esse contenute sono:
//  - Informazioni sul posto:
//      - Nome del posto        (text field)
//      - Indirizzo del posto   (text field)
//  - Promemoria                (switch)
//  - Note                      (text field)
//
//  TODO: altre informazioni e sezioni da inserire:
//      - Immagini (per visualizzare foto relative al posto segnato)
//  - Note audio (per registrare note audio)
//  TODO: implementare l'espansione della cella delle note

#import "AddNewPlaceTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "CoreDataManager.h"
#import "PlaceMO+CoreDataClass.h"




@interface AddNewPlaceTableViewController ()

@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *nameTableViewCell;
@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *addressTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *reminderTabelViewCell;
@property (weak, nonatomic) IBOutlet TextFieldTableViewCell *notesTabelViewCell;
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
    // Alloca ed inizializza il CLLocationManager
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
    CLLocation *userLocation = [locations lastObject]; // Prendi l'ultima posizione disponibile
    
    // Imposta la posizione del centro della mappa sulla posizione dell'utente
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)); // Puoi regolare il valore di MKCoordinateSpan per il livello di zoom desiderato
    [self.mapView setRegion:region animated:YES];
}

// preleva lo stato dello switch
- (void)switchChanged:(UISwitch *)sender {
    NSLog(@"Switch changed %d", sender.isOn);
    
    self.placeRemember = sender.isOn;
}


- (void)doneButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Conferma"
                                                                   message:@"Vuoi confermare?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Conferma"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        // preleva i dati dai text field
        TextFieldTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        TextFieldTableViewCell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        TextFieldTableViewCell *notesCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        NSString *placeName = nameCell.textField.text;
        NSString *placeAddress = addressCell.textField.text;
        NSString *notes = notesCell.textField.text;
        
        // controlla che i campi di nome e indirizzo non siano vuoti
        if ([placeName isEqualToString:@""] || [placeAddress isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Errore"
                                                                           message:@"Nome e indirizzo non possono essere vuoti"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
            
            [alert addAction:confirmAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        
        self.placeName = placeName;
        self.placeAddress = placeAddress;
        self.placeNotes = notes;
        NSDate *currentDate = [NSDate date];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSInteger timeZoneOffset = [timeZone secondsFromGMTForDate:currentDate];

        NSDate *localDate = [currentDate dateByAddingTimeInterval:timeZoneOffset];
        self.placeInsertTime = localDate;
        
        // location
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:placeAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Errore nella geocodifica: %@", error.localizedDescription);
                return;
            }
            
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                CLLocation *location = placemark.location;
                
                self.placeLatitude = location.coordinate.latitude;
                self.placeLongitude = location.coordinate.longitude;
                
                // dalle coordinate ottenute, ricava l'indirizzo completo (via, numero civico, cap, città, provincia, nazione)
                location = [[CLLocation alloc] initWithLatitude:self.placeLatitude longitude:self.placeLongitude];
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Errore nella geocodifica: %@", error.localizedDescription);
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
                    
                    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
                    
                    if (context) {
                        if (self.placeToEdit) {
                            // modifica un posto esistente
                            self.placeToEdit.name = self.placeName;
                            self.placeToEdit.address = self.placeAddress;
                            self.placeToEdit.notes = self.placeNotes;
                            self.placeToEdit.remember = self.placeRemember;
                            self.placeToEdit.insert_time = self.placeInsertTime;
                            self.placeToEdit.latitude = self.placeLatitude;
                            self.placeToEdit.longitude = self.placeLongitude;
                            
                            
                            
                            NSLog(@"Place: name: %@, address: %@, notes: %@, remember: %d, insert_time: %@, latitude: %f, longitude: %f",
                                  self.placeToEdit.name,
                                  self.placeToEdit.address,
                                  self.placeToEdit.notes,
                                  self.placeToEdit.remember,
                                  self.placeToEdit.insert_time,
                                  self.placeToEdit.latitude,
                                  self.placeToEdit.longitude);
                            
                            
                            NSError *error = nil;
                            if (![context save:&error]) {
                                NSLog(@"Errore durante il salvataggio dei dati: %@\n", error);
                            } else {
                                NSLog(@"Dati salvati con successo!\n");
                                
                                // Avvisa il delegate dell'aggiunta di un nuovo posto
                                [self.delegate didEditPlace:self.placeToEdit];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }
                            
                            return;
                        
                        } else {
                            PlaceMO *newPlace = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
                            
                            newPlace.name = self.placeName;
                            newPlace.address = self.placeAddress;
                            newPlace.notes = self.placeNotes;
                            newPlace.remember = self.placeRemember;
                            newPlace.insert_time = self.placeInsertTime;
                            newPlace.latitude = self.placeLatitude;
                            newPlace.longitude = self.placeLongitude;
                            
                            
                            
                            
                            
                            NSLog(@"Place: name: %@, address: %@, notes: %@, remember: %d, insert_time: %@, latitude: %f, longitude: %f",
                                  newPlace.name,
                                  newPlace.address,
                                  newPlace.notes,
                                  newPlace.remember,
                                  newPlace.insert_time,
                                  newPlace.latitude,
                                  newPlace.longitude);
                            
                            
                            
                            
                            
                            
                            
                            
                            NSError *error = nil;
                            if (![context save:&error]) {
                                NSLog(@"Errore durante il salvataggio dei dati: %@\n", error);
                            } else {
                                NSLog(@"Dati salvati con successo!\n");
                                
                                // Avvisa il delegate dell'aggiunta di un nuovo posto
                                [self.delegate didAddNewPlace:newPlace];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }
                        }
                    } else {
                        NSLog(@"Errore: contesto di gestione del database non trovato!\n");
                    }
                    
                }];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Annulla"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.tag == 0)                 // nome del posto
        self.placeName = textField.text;
    else if (textField.tag == 1)            // indirizzo del posto
        self.placeAddress = textField.text;
    else if (textField.tag == 2)            // note
        self.placeNotes = textField.text;
    
    NSLog(@"Text field: %@\n", textField.text);
    
    return YES;
}


// impostazione delle celle della tabella
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // mappa
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        if (self.placeToEdit) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(self.placeToEdit.latitude, self.placeToEdit.longitude);
            [self.mapView addAnnotation:annotation];
            
            // centra la mappa sulla posizione del posto
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
            [self.mapView setRegion:region animated:YES];
            
        }
        
        return cell;
    }

    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // nome del posto
            static NSString *NameCellIdentifier = @"TextFieldTableViewCell";
            TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NameCellIdentifier
                                                                                                     forIndexPath:indexPath];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell"
                                                             owner:self
                                                           options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell configureWithTitle:@"Name" placeholder:@"Place name"];
            
            if (self.placeToEdit) {
                cell.textField.text = self.placeToEdit.name;
            }
            
            cell.textField.tag = 0;
           
            return cell;
        } else if (indexPath.row == 1) {
            // indirizzo del posto
            static NSString *NameCellIdentifier = @"TextFieldTableViewCell";
            TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NameCellIdentifier
                                                                                                     forIndexPath:indexPath];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell"
                                                             owner:self
                                                           options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell configureWithTitle:@"Address" placeholder:@"Place address"];
            if (self.placeToEdit) {
                cell.textField.text = self.placeToEdit.address;
            }
            cell.textField.tag = 1;
            cell.textField.textContentType = UITextContentTypeAddressCityAndState;
            
            
            
            
            return cell;
            
        }
        
    } else if (indexPath.section == 2) {
        // promemoria
        static NSString *ReminderCellIdentifier = @"ReminderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReminderCellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReminderCellIdentifier];
        }
        
        cell.textLabel.text = @"Reminder";
        
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        
        // setta lo stato dello switch
        if (self.placeToEdit) {
            self.placeRemember = self.placeToEdit.remember;
        }
        
        [switchView setOn:self.placeRemember animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        
        
        return cell;
        
    } else if (indexPath.section == 3) {
        // note
        static NSString *NotesCellIdentifier = @"TextFieldTableViewCell";
        
        TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier
                                                                                             forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell"
                                                         owner:self
                                                       options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell configureWithTitle:@"Notes" placeholder:@"Place notes"];
        
        if (self.placeToEdit) {
            cell.textField.text = self.placeToEdit.notes;
        }
        
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        
        cell.textField.tag = 2;
        
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250;
    }
    
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        // promemoria
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        label.text = @"Set a reminder to notify you when you get close to your saved location";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        
        return label;
    }
    
    return nil;
}

// rimuove la selezione fissa della cella
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    if (section == 0)       // mappa
        return 1;           // cella con la mappa
    else if (section == 1)  // informazioni
        return 2;           // nome e indirizzo
    else if (section == 2)  // promemoria
        return 1;           // switch promemoria
    else if (section == 3)  // note
        return 1;           // text field per le note
    
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
