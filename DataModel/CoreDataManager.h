//
//  CoreDataManager.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype) sharedManager;
- (NSManagedObjectContext *) managedObjectContext;
- (void) saveContext;

@end

NS_ASSUME_NONNULL_END
