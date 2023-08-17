//
//  PlaceMO+CoreDataProperties.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 17/08/23.
//
//

#import "PlaceMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) BOOL remember;
@property (nullable, nonatomic, copy) NSDate *insert_time;

@end

NS_ASSUME_NONNULL_END
