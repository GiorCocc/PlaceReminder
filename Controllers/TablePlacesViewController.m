//
//  TablePlacesViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//
//  Questo ViewController ha il compito di mostrare una mappa contenente la posizione dell'utente e i luoghi preferiti vicino a lui
//  Sotto alla mappa è presente una TableView con celle dinamiche che mostrano, in una struttura subtitle, il nome del luogo e il suo indirizzo
//  Cliccando su una cella si apre una nuova schermata che mostra i dettagli del luogo selezionato
//  I luoghi sono presenti nel database e vanno recuperati da li
//  In alto a destra è presente un bottone che permette di aggiungere un nuovo luogo e il pulsante per andare a vedere la mappa a tutto schermo
//  TODO: implementare il passaggio alla schermata dei dettagli del luogo selezionato
//  TODO: visualizzazione mappa
//  TODO: implementare swipe to delete sulle celle per rimuovere un luogo

#import "TablePlacesViewController.h"
#import "CoreDataManager.h"
#import "PlaceMO+CoreDataProperties.h"
#import "PlaceDetailsViewController.h"



@interface TablePlacesViewController ()

@property (nonatomic, strong) NSArray *places;

@end



@implementation TablePlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Esegui la query per ottenere i luoghi dal database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Errore nel caricamento dei luoghi: %@", error);
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the number of rows
    return self.places.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PlaceMO *place = self.places[indexPath.row];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.address;
    
    // Configure the cell...
    
    return cell;
}


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

/*- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceMO *selectedPlaceMO = self.places[indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowDetailsSegue" sender:selectedPlaceMO];
}*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetailsSegue"]) {
        PlaceDetailsViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.selectedPlaceMO = sender;
    }
}*/

@end
