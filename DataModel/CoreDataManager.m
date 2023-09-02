//
//  CoreDataManager.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//
//  This class is used to manage CoreData operations and to access the database.

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize persistentContainer = _persistentContainer;

//  Singleton pattern implementation to ensure that only one instance of the class is created.
+ (instancetype) sharedManager {
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

//  Returns the persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
- (NSPersistentContainer *) persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PlaceCoreDataModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler: ^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

//  Saves the current state of the managed object context.
- (void) saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (NSManagedObjectContext *) managedObjectContext {
    return self.persistentContainer.viewContext;
}

@end
