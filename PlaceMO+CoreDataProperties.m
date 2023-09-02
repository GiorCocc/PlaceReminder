//
//  PlaceMO+CoreDataProperties.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 18/08/23.
//
//

#import "PlaceMO+CoreDataProperties.h"

@implementation PlaceMO (CoreDataProperties)

//  Returns a fetch request initialized with the given entity name.
+ (NSFetchRequest<PlaceMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Place"];
}

@dynamic address;       // place address (human readable - reverse geocoded) !! NECCESSARY !!
@dynamic name;          // place name !! NECCESSARY !!
@dynamic notes;         // place notes
@dynamic remember;      // flag to remember the place and set a geofence region
@dynamic insert_time;   // place insert time
@dynamic latitude;      // place latitude (geocoded from address) !! CREATED AUTOMATICALLY !!
@dynamic longitude;     // place longitude (geocoded from address) !! CREATED AUTOMATICALLY !!

@end
