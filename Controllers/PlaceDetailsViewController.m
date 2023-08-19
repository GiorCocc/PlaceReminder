//
//  TablePinnedPlaceViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//
//  ViewController per la visualizzazione dei dettagli del posto selezionato nella lista della HomePage
//  TODO: aggiungere la possibilità di impostare un promemoria per il posto

#import "PlaceDetailsViewController.h"
#import "CoreDataManager.h"
#import "AddNewPlaceTableViewController.h"

@interface PlaceDetailsViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *mapCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *insertTimeCell;
@property (weak, nonatomic) IBOutlet UISwitch *switchReminder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openInMapBarButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PlaceDetailsViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Showing selected place details: %@", self.selectedPlaceMO);
    
    // titolo
    self.title = self.selectedPlaceMO.name;
    
    // map
    self.mapView.delegate = self;
    // Create a location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    // annotazione sulla mappa
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.selectedPlaceMO.latitude, self.selectedPlaceMO.longitude);
    [self.mapView addAnnotation:annotation];
    // centra la mappa sulla posizione dell'annotazione
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    // zoom sulla posizione dell'annotazione
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
    
    
    
    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // aggiorna i dati nella schermata
    [self updateUIWithData:self.selectedPlaceMO];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self updateMapViewWithPlace:self.selectedPlaceMO];
}

#pragma mark Map

- (void) updateMapViewWithPlace:(PlaceMO *)place {
    // aggiorna la mappa con il posto selezionato
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    [self.mapView addAnnotation:annotation];
    // centra la mappa sulla posizione dell'annotazione
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    // zoom sulla posizione dell'annotazione
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}



- (void)updateUIWithData:(PlaceMO *)place {
    // aggiorna i dati nella schermata
    self.title = place.name;
    
    self.nameCell.detailTextLabel.text = place.name;
    self.addressCell.detailTextLabel.text = place.address;
    self.insertTimeCell.detailTextLabel.text = [place.insert_time description];
    self.switchReminder.on = place.remember;
    self.notesCell.detailTextLabel.text = place.notes;
    [self updateMapViewWithPlace:place];
}

- (void) didEditPlace:(PlaceMO *)editedPlace {
    // Aggiorna l'oggetto PlaceMO visualizzato e i dati nella schermata
    NSLog(@"Edited place: %@", editedPlace);
    self.selectedPlaceMO = editedPlace;
    [self updateUIWithData:editedPlace];
    // rimuovi le annotazioni precedenti
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self updateMapViewWithPlace:editedPlace];
}

- (void) didAddNewPlace:(nonnull PlaceMO *)place {}


- (IBAction)removePlaceButtonPressed:(id)sender {
    NSLog(@"Remove place button pressed");
    
    // crea un alert per chiedere conferma
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove"
                                                                   message:@"Sei sicuro di voler rimuovere questo posto?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Rimuovi"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
        // rimuovi il posto dal database
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
        [context deleteObject:self.selectedPlaceMO];
        
        NSError *error = nil;
        [context save:&error];
        
        if (error) {
            NSLog(@"Errore nel salvataggio del contesto: %@", error);
        }
        
        [self.delegate didRemovePlace:self.selectedPlaceMO];
        
        // torna indietro
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Annulla"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    // rimuovi il posto dal database
    // [[CoreDataManager sharedManager] removePlace:self.selectedPlaceMO];
    
    // torna indietro
    // [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)openInMap:(id)sender {
    NSLog(@"Open in map button pressed");
    
    // apri il posto in Maps
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.selectedPlaceMO.latitude, self.selectedPlaceMO.longitude);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.selectedPlaceMO.name;
    [mapItem openInMapsWithLaunchOptions:nil];
    
}

- (IBAction)sharePlaceInfo:(id)sender {
    NSLog(@"Share place info button pressed");
    
    // open the share menu
    NSString *textToShare = [NSString stringWithFormat:@"Ti condivido volentieri questo posto che ho trovato: %@, %@",
                             self.selectedPlaceMO.name, self.selectedPlaceMO.address];
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                                                             applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        // mappa
        return cell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.selectedPlaceMO.name;
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.selectedPlaceMO.address;
        } else if (indexPath.row == 2) {
            NSString *insertTime = [NSDateFormatter localizedStringFromDate:self.selectedPlaceMO.insert_time
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            
            cell.detailTextLabel.text = insertTime;
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        // promemoria
        // imposta lo switch in base al valore del reminder
        if (self.selectedPlaceMO.remember) {
            [self.switchReminder setOn:YES];
        } else {
            [self.switchReminder setOn:NO];
        }
        
        
        return cell;
    } else if (indexPath.section == 3) {
        // note
        if (self.selectedPlaceMO.notes == nil || [self.selectedPlaceMO.notes isEqualToString:@""]) {
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            
            
            cell.detailTextLabel.text = @"Nessuna nota";
        } else {
            cell.detailTextLabel.text = self.selectedPlaceMO.notes;
        }
        
        
        
        return cell;
    }
    
    
    
    
    return nil;
}

// update the place reminder flag when the switch is toggled
- (IBAction)updatePlaceReminder:(id)sender {
    NSLog(@"Update place reminder");
    
    // aggiorna il posto con il nuovo valore del reminder
    self.selectedPlaceMO.remember = self.switchReminder.isOn;
    
    // salva il contesto
    NSError *error = nil;
    [[CoreDataManager sharedManager].managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Errore nel salvataggio del contesto: %@", error);
    }
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
        return 3;           // nome e indirizzo
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


#pragma mark - Navigation

- (IBAction)editPlace:(id)sender {
    NSLog(@"Edit place button pressed");
    
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
            
            // Passa il PlaceMO selezionato alla schermata dei dettagli
            detailVC.placeToEdit = sender;
            
        }
    }
}




@end
