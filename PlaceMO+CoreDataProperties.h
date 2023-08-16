//
//  PlaceMO+CoreDataProperties.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//
//

#import "PlaceMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int16_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) BOOL remember;
@property (nullable, nonatomic, copy) NSString *notes;

@end

NS_ASSUME_NONNULL_END
