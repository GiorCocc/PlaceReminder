//
//  HomePageViewController.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 17/08/23.
//
//  Questo ViewController ha il compito di mostrare una mappa contenente la posizione dell'utente e i luoghi preferiti vicino a lui
//  Sotto alla mappa è presente una TableView con celle dinamiche che mostrano, in una struttura subtitle, il nome del luogo e il suo indirizzo
//  Cliccando su una cella si apre una nuova schermata che mostra i dettagli del luogo selezionato
//  I luoghi sono presenti nel database e vanno recuperati da li
//  In alto a destra è presente un bottone che permette di aggiungere un nuovo luogo e il pulsante per andare a vedere la mappa a tutto schermo
//  TODO: implementare il passaggio alla schermata dei dettagli del luogo selezionato
//  TODO: visualizzazione mappa

#import "HomePageViewController.h"
#import "CoreDataManager.h"
#import "PlaceMO+CoreDataProperties.h"
#import "AddNewPlaceTableViewController.h"





@interface HomePageViewController () <AddNewPlaceDelegate>

@property (nonatomic, strong) NSMutableArray *places;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Esegui la query per ottenere i luoghi dal database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Errore nel caricamento dei luoghi: %@", error);
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    // Aggiorna la tabella per mostrare i luoghi aggiunti
    [self.tableView reloadData];
}

- (void)didAddNewPlace: (PlaceMO *) newPlace {
    // Aggiorna i dati (array places) e ricarica la tabella
    NSLog(@"didAddNewPlace chiamato dal delegate");
    [self.places addObject:newPlace];
    [self.tableView reloadData];
}

- (IBAction)presentAddNewPlaceViewController {
    AddNewPlaceTableViewController *addNewPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewPlaceViewController"];
    addNewPlaceVC.delegate = self;
    // presenta il view controller come push
    [self.navigationController pushViewController:addNewPlaceVC animated:YES];

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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Crea un alert per chiedere conferma della cancellazione
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cancellazione luogo" message:@"Sei sicuro di voler cancellare questo luogo?" preferredStyle:UIAlertControllerStyleAlert];
        
        // Aggiungi l'azione per la cancellazione
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Cancella" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // Cancellare il luogo dal database
            PlaceMO *place = self.places[indexPath.row];
            NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
            [context deleteObject:place];
            
            NSError *error = nil;
            [context save:&error];
            
            if (error) {
                NSLog(@"Errore nel salvataggio del contesto: %@", error);
            } else {
                // Rimuovi il luogo dall'array dei dati
                [self.places removeObjectAtIndex:indexPath.row];
                
                // Elimina la cella dalla tabella con animazione di dissolvenza
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
        // Aggiungi l'azione per annullare la cancellazione
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleCancel handler:nil];
        
        // Aggiungi le azioni all'alert
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        
        // Mostra l'alert
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
