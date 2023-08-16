//
//  CoreDataManager.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize persistentContainer = _persistentContainer;

+ (instancetype) sharedManager {
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

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
